package com.coderstack.clinicgrid.repository;

import com.coderstack.clinicgrid.model.Logs;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface LogsRepository extends MongoRepository<Logs, String> {
}
