package com.coderstack.clinicgrid.controller;

import com.coderstack.clinicgrid.exceptions.ResourceNotFoundException;
import com.coderstack.clinicgrid.model.Hospital;
import com.coderstack.clinicgrid.model.MedSale;
import com.coderstack.clinicgrid.model.Sale;
import com.coderstack.clinicgrid.repository.HospitalRepository;
import com.coderstack.clinicgrid.repository.SaleRepository;
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hospital/{hospital_id}/{role}/{user_id}")
public class SalePdfController {

    @Autowired
    private SaleRepository saleRepository;

    @Autowired
    private HospitalRepository hospitalRepository;

    @GetMapping("/sale/{saleId}/pdf")
    public ResponseEntity<?> generateSalePdf(@PathVariable int saleId,@PathVariable int hospital_id) throws Exception {
        Hospital hospital = hospitalRepository.findById(hospital_id)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid hospital"));
        Sale sale = saleRepository.findByIdAndHospital(saleId,hospital);
        if(sale == null){
            return ResponseEntity.status(400).body(Map.of("error","Invalid sales"));
        }

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, out);

        document.open();
        document.addTitle("Sale Report");

        document.add(new Paragraph("Sale Report", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18)));
        document.add(new Paragraph("Sale ID: " + sale.getId()));
        document.add(new Paragraph("Hospital: " + sale.getHospital().getHospitalName()));
        document.add(new Paragraph("Patient: " + sale.getPatient().getFirstName() + " " + sale.getPatient().getFirstName()));
        document.add(new Paragraph("Date: " + sale.getPaymentDoneOn()));
        document.add(new Paragraph("Total Amount: ₹" + sale.getAmount()));
        document.add(new Paragraph(" "));

        PdfPTable table = new PdfPTable(4); // 4 columns
        table.addCell("Medicine");
        table.addCell("Quantity");
        table.addCell("Price");
        table.addCell("Subtotal");

        List<MedSale> items = sale.getMedSales();
        for (MedSale item : items) {
            table.addCell(item.getMedicine().getName());
            table.addCell(String.valueOf(item.getTotalSold()));
            table.addCell("₹" + item.getPrice());
            int subtotal = item.getPrice() * item.getTotalSold();
            table.addCell("₹" + subtotal);
        }

        document.add(table);
        document.close();

        byte[] pdfBytes = out.toByteArray();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDisposition(ContentDisposition.builder("inline")
                .filename("sale_" + saleId + ".pdf").build());

        return ResponseEntity.ok().headers(headers).body(pdfBytes);
    }
}
