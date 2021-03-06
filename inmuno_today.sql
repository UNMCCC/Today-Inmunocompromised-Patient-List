/* NEW QUERY for patients with alert types of IMMUNOCOMPROMISED - */
/* no restrictions on activities -- see comments in code for documentation  */
/* Pull early for today's actually -- originally written for run last night */
/* Debbie Healy, June 2020 */
SET NOCOUNT ON;
SELECT 
    Quotename(vwS.PAT_NAME,'"') as PAT_NAME,    
      vwS.IDA as MRN,
      convert(varchar,vwS.App_dtTm,20) as App_dtTm,
      vwS.Activity,
    --  vwS.cgroup as activity_group,
    --  cpt.cpt_code as activity_cat,
      vwS.Location as Sch_location,
    --  vwS.Notes as Sch_Notes,
    --  isNull(convert(char(10),ART.ID_Partial_DtTm, 101), ' ') AS Alert_Identified_Dt,
    -- ART.Alert_obd_id,  -- alert ObsDef id
    -- obd.label as obd_Alert_Type,
    -- obd.Description as obd_Alert_Desc,					-- drop down value from ObsDef  
	 --ART.ART_Status_Enum,
	-- case 
		--when ART.ART_Status_Enum = 1 then 'Active'
		--when ART.ART_Status_Enum = 2 then 'Inactive'
		--when ART.ART_Status_Enum = 3 then 'Void'
	 -- end alert_Status,
     -- MOSAIQ.dbo.fn_GetStaffName(vwS.staff_id,'NAMELF') as staff_Name,
     Quotename(MOSAIQ.dbo.fn_GetStaffName(vws.Attending_Md_Id, 'NAMELF'),'"') as attending_MD, 
      isNull(ART.Comments, ' ') as Alert_Staff_Comments	-- Free Text 
    --  vwS.SysDefStatus as Sch_Status
FROM MOSAIQ.dbo.vw_Schedule vwS
LEFT JOIN MOSAIQ.dbo.patAlert ART	on vwS.pat_id1 = ART.pat_id1 
--INNER JOIN MOSAIQ.dbo.Ident			on vwS.Pat_ID1 = Ident.Pat_id1
--INNER JOIN MOSAIQ.dbo.Admin			on vwS.Pat_ID1 = Admin.Pat_id1
--INNER JOIN MOSAIQ.dbo.Patient		on vwS.Pat_ID1 = Patient.Pat_ID1
--LEFT JOIN MOSAIQ.dbo.CPT cpt		on vwS.activity = cpt.Hsp_Code
LEFT JOIN MOSAIQ.dbo.ObsDef	obd		on ART.Alert_OBD_ID = obd.OBD_ID
WHERE 
   ART.version = 0					-- Alert Tip Record
  AND convert(char(8),vwS.app_DtTm,112) >= convert(char(8),GetDate(), 112)		-- Scheduled Appointment from "today"
  AND convert(char(8),vwS.app_DtTm,112) < convert(char(8),GetDate()+1, 112)    -- SHOULD BE +1, and "< convert"
  AND  ART.ART_Status_Enum = 1                                                                --Through Scheduled Appointment "tommorrow"
  AND (vwS.SysDefStatus is NULL OR vwS.SysDefStatus <> 'X')			-- Appointment has NOT been cancelled
  AND 
( --  There are two conditions to check
	( -- 1 -- Check Alert Type IMMUNOCOMPROMISED
	obd.Tbl = 10013			-- OBSDEF Table (Observation Definition) Table_id = 10013 provides the list of Alert Types containted in the PatAlert Table (Patient Alert)
	AND obd.obd_id = 25175		-- ObdDef.obdid = 25175 is the id for Alert Type = 'Immunocompromised' -- activated on 6/3/2020
 	) 
 
 OR 
	 ( -- 2 -- Check Alert Type ISOLATION
	 	obd.obd_id =  21601		-- ObdDef.obdid = 21601 is the id for Alert Type = ISOLATION
	 	AND art.comments = 'IMMUNOCOMPROMISED'  -- pre 6/3/2020 the combo of Type=ISOLATION and Comment=IMMUNOCOMPROMISED was used to id patients.  keep this criteria in case someone inadvertently uses it
  	)
)
order by PAT_NAME