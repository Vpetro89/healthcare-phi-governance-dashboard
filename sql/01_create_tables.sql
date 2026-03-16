CREATE TABLE contracts (
    contract_id VARCHAR(20) PRIMARY KEY,
    partner_name VARCHAR(200),
    partner_type VARCHAR(50),
    effective_date DATE,
    expiration_date DATE,
    data_use_case VARCHAR(255),
    authorization_scope VARCHAR(255),
    status VARCHAR(50),
    legal_owner VARCHAR(100),
    renewal_required BOOLEAN,
    created_at TIMESTAMP,
    created_by VARCHAR(100),
    updated_at TIMESTAMP,
    updated_by VARCHAR(100),
    CONSTRAINT chk_contract_dates CHECK (expiration_date >= effective_date)
);

CREATE TABLE projects (
    project_id VARCHAR(20) PRIMARY KEY,
    project_name VARCHAR(255),
    contract_id VARCHAR(20),
    servicenow_ticket VARCHAR(50),
    owner_team VARCHAR(100),
    implementation_status VARCHAR(50),
    go_live_date DATE,
    platform VARCHAR(50),
    last_updated DATE,
    created_at TIMESTAMP,
    created_by VARCHAR(100),
    updated_at TIMESTAMP,
    updated_by VARCHAR(100),
    CONSTRAINT fk_projects_contract
        FOREIGN KEY (contract_id)
        REFERENCES contracts(contract_id)
);

CREATE TABLE interfaces (
    interface_id VARCHAR(20) PRIMARY KEY,
    project_id VARCHAR(20),
    endpoint_name VARCHAR(255),
    endpoint_url VARCHAR(500),
    interface_type VARCHAR(50),
    protocol VARCHAR(50),
    message_standard VARCHAR(50),
    authentication_method VARCHAR(50),
    source_system VARCHAR(100),
    destination_partner VARCHAR(200),
    active_flag BOOLEAN,
    technical_owner VARCHAR(100),
    endpoint_status VARCHAR(50),
    created_at TIMESTAMP,
    created_by VARCHAR(100),
    updated_at TIMESTAMP,
    updated_by VARCHAR(100),
    CONSTRAINT fk_interfaces_project
        FOREIGN KEY (project_id)
        REFERENCES projects(project_id)
);

CREATE TABLE data_elements (
    data_element_id VARCHAR(20) PRIMARY KEY,
    data_element_name VARCHAR(100),
    domain VARCHAR(50),
    sensitivity_level VARCHAR(50),
    data_classification VARCHAR(50),
    phi_flag BOOLEAN,
    hl7_segment VARCHAR(10),
    hl7_field VARCHAR(10),
    hl7_component VARCHAR(10),
    hl7_subcomponent VARCHAR(10),
    fhir_resource VARCHAR(50),
    fhir_path VARCHAR(200),
    created_at TIMESTAMP,
    created_by VARCHAR(100),
    updated_at TIMESTAMP,
    updated_by VARCHAR(100)
);

CREATE TABLE authorized_data_elements (
    contract_id VARCHAR(20),
    data_element_id VARCHAR(20),
    authorization_status VARCHAR(50),
    created_at TIMESTAMP,
    created_by VARCHAR(100),
    PRIMARY KEY (contract_id, data_element_id),
    CONSTRAINT fk_authorized_contract
        FOREIGN KEY (contract_id)
        REFERENCES contracts(contract_id),
    CONSTRAINT fk_authorized_element
        FOREIGN KEY (data_element_id)
        REFERENCES data_elements(data_element_id)
);

CREATE TABLE interface_data_elements (
    interface_id VARCHAR(20),
    data_element_id VARCHAR(20),
    implemented_flag BOOLEAN,
    created_at TIMESTAMP,
    created_by VARCHAR(100),
    PRIMARY KEY (interface_id, data_element_id),
    CONSTRAINT fk_interface_element_interface
        FOREIGN KEY (interface_id)
        REFERENCES interfaces(interface_id),
    CONSTRAINT fk_interface_element_data
        FOREIGN KEY (data_element_id)
        REFERENCES data_elements(data_element_id)
);

CREATE INDEX idx_projects_contract
    ON projects(contract_id);

CREATE INDEX idx_interfaces_project
    ON interfaces(project_id);

CREATE INDEX idx_interface_partner
    ON interfaces(destination_partner);

CREATE INDEX idx_authorized_contract
    ON authorized_data_elements(contract_id);

CREATE INDEX idx_interface_elements_interface
    ON interface_data_elements(interface_id);