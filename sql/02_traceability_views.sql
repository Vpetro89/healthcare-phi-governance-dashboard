CREATE VIEW v_contract_project_interface AS
SELECT
    c.contract_id,
    c.partner_name,
    c.partner_type,
    c.status AS contract_status,
    c.effective_date,
    c.expiration_date,
    p.project_id,
    p.project_name,
    p.servicenow_ticket,
    p.implementation_status,
    p.go_live_date,
    i.interface_id,
    i.endpoint_name,
    i.endpoint_url,
    i.protocol,
    i.message_standard,
    i.source_system,
    i.destination_partner,
    i.active_flag,
    i.endpoint_status
FROM contracts c
LEFT JOIN projects p
    ON c.contract_id = p.contract_id
LEFT JOIN interfaces i
    ON p.project_id = i.project_id;



CREATE VIEW v_orphaned_projects AS
SELECT
    p.project_id,
    p.project_name,
    p.contract_id,
    p.servicenow_ticket,
    p.owner_team,
    p.implementation_status,
    p.go_live_date
FROM projects p
LEFT JOIN contracts c
    ON p.contract_id = c.contract_id
WHERE p.contract_id IS NULL
   OR c.contract_id IS NULL;



CREATE VIEW v_orphaned_interfaces AS
SELECT
    i.interface_id,
    i.endpoint_name,
    i.endpoint_url,
    i.project_id,
    p.contract_id,
    i.destination_partner,
    i.protocol,
    i.message_standard,
    i.active_flag,
    i.endpoint_status
FROM interfaces i
LEFT JOIN projects p
    ON i.project_id = p.project_id
LEFT JOIN contracts c
    ON p.contract_id = c.contract_id
WHERE i.active_flag = TRUE
  AND (
        p.project_id IS NULL
     OR p.contract_id IS NULL
     OR c.contract_id IS NULL
  );



CREATE VIEW v_authorized_vs_implemented AS
SELECT
    p.contract_id,
    i.interface_id,
    i.endpoint_name,
    ide.data_element_id,
    de.data_element_name,
    de.domain,
    de.sensitivity_level,
    de.phi_flag,
    CASE
        WHEN ade.data_element_id IS NOT NULL
            THEN 'Authorized'
        ELSE 'Not Authorized'
    END AS authorization_status,
    ide.implemented_flag
FROM interfaces i
JOIN projects p
    ON i.project_id = p.project_id
JOIN interface_data_elements ide
    ON i.interface_id = ide.interface_id
JOIN data_elements de
    ON ide.data_element_id = de.data_element_id
LEFT JOIN authorized_data_elements ade
    ON p.contract_id = ade.contract_id
   AND ide.data_element_id = ade.data_element_id;