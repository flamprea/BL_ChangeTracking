Jython Change Tracking
1.0 	Jarrod Boland
1.1 	Bill Robinson
1.2 	Bill Robinson - updated error checking
1.3 	Bill Robinson - lots of rework.  requires jython 2.2 (datetime module) for the SNMP notify option
1.4 	Bill Robinson - misc updates
1.5 	Bill Robinson - added some error handling
1.6 	Frank Lamprea - lots of rework. Added support for changes windows
1.7 	Frank Lamprea - a few fixes
1.8 	Frank Lamprea - Added property CW_ID. This allows a Ticket, CMR or other identifying number to be associated with each audit job. If the value is empty the script functions exactly as v1.7
1.8.1	Frank Lamprea - Fixed Snapshot DBKey sorting errors (post 7.4.X)
1.8.2	Frank Lamprea - Change Snapshot Targeting from Components to Component Smart Group. This saves considerable Disk Space
**********************************************************************************************************************************************

This script is used for an automated scheduled snapshot and audit process.  It will automatically
snapshot a component and compare it to the last snapshot.  For example this can be used to 
see what changes on a component from day to day.

The Job will create a snapshot job for each template, run the snapshot job, 
create an audit job for each component and either run the audit jobs w/ or w/o SNMP notification.

If a snapshot fails against a host, the audit for that night will not be run until a good snapshot is created

**********************************************************************************************************************************************
You can run this script from CM using the included NSH scripts.  Put the jython 
scripts at a location reachable by the appserver and import the NSH scripts
as a Type 2 NSH script in the Configuration Manager.

**********************************************************************************************************************************************
Place the included XML files in the custom commands directory - <OM dir>/br/xml/cli
Place the included Jython files in the sensors directory - <OM dir>/share/sensors
**********************************************************************************************************************************************

The following server properties are required if using v1.6+. Be aware the properties are case-sensitive

CW_ACTIVE			Type:Simple/Boolean		Default Value:false Editable and Not Required 	Desc: Set to True when servers is in a change window
CW_ALL_SS_KEY		Type:Simple/String		Default Value:blank Editable and Not Required	Desc: Tracks the last known "Authorized" snapshot
CW_LAST_SS_KEY		Type:Simple/String		Default Value:blank Editable and Not Required	Desc: Tracks the last known "Unauthorized" snapshot
CW_CHANGE_COMPLETE	Type:Simple/Boolean		Default Value:false Editable and Not Required	Desc: When set to true indicates that the Authorized changes have been completed
CW_CYCLED			Type:Simple/Boolean		Default Value:false Editable and Not Required	Desc: When set to true indicates that the server has had at least one Authorized Change Window cycle since the last audit.
CW_SNAPSHOT_PASS	Type:Simple/Boolean		Default Value:false Editable and Not Required	Desc: Used for tracking Snapshot progress during a change window
CW_ID				Type:Simple/String		Default Value:unknown Editable and Not Required	Desc: Tracks the change number(s) or change ID(s) associated with the current Audit.		

The following BLCLI commands can be run to automatically create the properties.

blcli PropertyClass addProperty Class://SystemObject/Server CW_ACTIVE "Set to True when servers is in a change window" Primitive:/Boolean true false false
blcli PropertyClass addProperty Class://SystemObject/Server CW_ALL_SS_KEY "Tracks the last known Authorized snapshot" Primitive:/String true false ""
blcli PropertyClass addProperty Class://SystemObject/Server CW_LAST_SS_KEY "Tracks the last known Unauthorized snapshot" Primitive:/String true false ""
blcli PropertyClass addProperty Class://SystemObject/Server CW_CHANGE_COMPLETE "When set to true indicates that the server has had at least one Authorized Change Window cycle since the last audit." Primitive:/Boolean true false false
blcli PropertyClass addProperty Class://SystemObject/Server CW_CYCLED "When set to true indicates that the Authorized changes have been completed" Primitive:/Boolean true false false
blcli PropertyClass addProperty Class://SystemObject/Server CW_ID "Tracks the change number(s) or change ID(s) associated with the current Audit" Primitive:/String true false ""
blcli PropertyClass addProperty Class://SystemObject/Server CW_SNAPSHOT_PASS "Used for tracking Snapshot progress during a change window" Primitive:/Boolean true false false

**********************************************************************************************************************************************
Please note Jython 2.2 is required.

**********************************************************************************************************************************************
If you are using these scripts with an Appserver prior to v7.4.3 you will need to make a small update to the <OM dir>/br/sqmap.properties file
on all Application servers. Open the file in a text editor and search for the line "SELECT_ALL_SNAPSHOTS_BY_COMPONENT_IGNORE_VERSION". This will 
take you to a SQL query that returns a list of DBKeys for snapshots related to a component. You need to add "ORDER BY jr.date_created; \" to the 
end of the query. A sample is displayed below:

SELECT_ALL_SNAPSHOTS_BY_COMPONENT_IGNORE_VERSION = \
SELECT jr.result_id, jr.job_id, jr.job_version_id, \
jr.job_run_id, jr.object_type_id, jr.name, \
jr.description, jr.date_created, jr.is_deleted, jr.date_modified \
FROM job_result jr, job_result_component jrc, job j \
WHERE \
j.job_id = jr.job_id \
AND j.job_version_id = jr.job_version_id \
AND jr.object_type_id = 9 \
AND jrc.component_id = ? \
AND jr.result_id = jrc.result_id \
AND jr.is_deleted = 0; \
ORDER BY jr.date_created; \
COMPONENT_ID

After sqlmap.properties has been updated on all servers you will need to restart the BladeLogic Application server process / service.

**********************************************************************************************************************************************
The "Sample Jobs", "Sample Reports" and "Sample Templates" folders included in the package can all be imported using BladeLogic's IMPORT/EXPORT 
functionality. The packages have been exported from a v7.4.1 Application Server. Importing into versions other than v7.4.1 may not be supported.

**********************************************************************************************************************************************





