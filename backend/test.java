import java.io.*;
import java.util.*;

public class Main {
    static Map<String, Component> rules = new HashMap<>();
    static List<String> order = new ArrayList<>();

    static class Component {
        String subComponent;
        int quantity;

        Component(String subComponent, int quantity) {
            this.subComponent = subComponent;
            this.quantity = quantity;
        }
    }

    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

        // Read the component order
        String[] components = br.readLine().split(",");
        for (String comp : components) {
            order.add(comp.trim());
        }

        // Read dependency rules
        String line;
        while ((line = br.readLine()) != null && !line.trim().isEmpty()) {
            // Example: Shelve is 2 Draw
            String[] parts = line.split(" is ");
            String parent = parts[0].trim();
            String[] subParts = parts[1].trim().split(" ");
            int qty = Integer.parseInt(subParts[0].trim());
            String child = subParts[1].trim();
            rules.put(parent, new Component(child, qty));
        }

        // Start from the last item (top component)
        String start = order.get(order.size() - 1);
        List<String> result = new ArrayList<>();
        buildResult(start, 1, result);

        // Output final result
        System.out.println(String.join(" equals ", result));
    }

    static void buildResult(String component, int multiplier, List<String> result) {
        result.add(multiplier + component);
        if (rules.containsKey(component)) {
            Component sub = rules.get(component);
            buildResult(sub.subComponent, multiplier * sub.quantity, result);
        }
    }
}
