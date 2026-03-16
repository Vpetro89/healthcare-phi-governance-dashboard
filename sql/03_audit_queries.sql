-- Active interfaces without valid contract authority
SELECT
    interface_id,
    endpoint_name,
    endpoint_url,
    project_id,
    contract_id,
    destination_partner,
    protocol,
    message_standard,
    endpoint_status
FROM v_orphaned_interfaces
ORDER BY interface_id;



-- Projects missing contract linkage
SELECT
    project_id,
    project_name,
    contract_id,
    servicenow_ticket,
    owner_team,
    implementation_status,
    go_live_date
FROM v_orphaned_projects
ORDER BY project_id;



-- Implemented data elements not explicitly authorized
SELECT
    contract_id,
    interface_id,
    endpoint_name,
    data_element_id,
    data_element_name,
    domain,
    sensitivity_level,
    phi_flag,
    implemented_flag
FROM v_authorized_vs_implemented
WHERE authorization_status = 'Not Authorized'
ORDER BY contract_id, interface_id, data_element_id;



-- Contract coverage summary
SELECT
    c.contract_id,
    c.partner_name,
    COUNT(DISTINCT p.project_id) AS project_count,
    COUNT(DISTINCT i.interface_id) AS interface_count,
    SUM(CASE WHEN i.active_flag = TRUE THEN 1 ELSE 0 END) AS active_interfaces
FROM contracts c
LEFT JOIN projects p
    ON c.contract_id = p.contract_id
LEFT JOIN interfaces i
    ON p.project_id = i.project_id
GROUP BY
    c.contract_id,
    c.partner_name
ORDER BY
    c.contract_id;



-- High sensitivity data exposure by partner
SELECT
    c.partner_name,
    de.sensitivity_level,
    COUNT(*) AS implemented_elements
FROM interfaces i
JOIN projects p
    ON i.project_id = p.project_id
JOIN contracts c
    ON p.contract_id = c.contract_id
JOIN interface_data_elements ide
    ON i.interface_id = ide.interface_id
JOIN data_elements de
    ON ide.data_element_id = de.data_element_id
WHERE de.sensitivity_level IN ('High', 'PHI')
GROUP BY
    c.partner_name,
    de.sensitivity_level
ORDER BY
    c.partner_name,
    de.sensitivity_level;