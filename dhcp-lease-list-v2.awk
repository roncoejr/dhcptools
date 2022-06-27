BEGIN {RS="}"; FS=";"; SNAP_TIME=strftime("%m/%d/%Y %H:%M:%S", systime())}
BEGIN {if (OUTPUT_FLAG=="csv") {printf "%s,%s,%s,%s,%s,%s,%s\n", "runStart", "ipAddress", "leaseEnd", "fieldThree", "leaseState","macAddress","hostName"}}
BEGIN {if (OUTPUT_FLAG=="json") {printf "{\n"}}
{match($1,/[1-9]+\.[1-9]+\.[0-9]+\.[0-9]+/); LEASE=substr($1,RSTART,RLENGTH)}
{match($2,/[0-9]+\/[0-9]+\/[0-9]+ [0-9]+\:[0-9]+\:[0-9]+/); LEASE_END=substr($2,RSTART,RLENGTH)}
{match($3,/[0-9]+\/[0-9]+\/[0-9]+ [0-9]+\:[0-9]+\:[0-9]+/); LEASE_TT=substr($3,RSTART,RLENGTH)}
{match($4,/(active|inactive)/); LEASE_STATE=substr($4,RSTART,RLENGTH)}
{match($7,/[a-f0-9]+\:[a-f0-9]+\:[a-f0-9]+\:[a-f0-9]+\:[a-f0-9]+\:[a-f0-9]++/); MAC_ADDR=substr($7,RSTART,RLENGTH)}
{KEY_FOUND = "NO"}
{VAR_INDEX = 9}
{while ((KEY_FOUND == "NO") && (VAR_INDEX >= 9 && VAR_INDEX <= 14)) {
	{match($VAR_INDEX,/client-hostname/) ; POS_KEY=substr($VAR_INDEX,RSTART,RLENGTH)}
	{if (POS_KEY=="client-hostname") {match($VAR_INDEX,/\"(.+)\"/); HOST_NAME=substr($VAR_INDEX,RSTART,RLENGTH); KEY_FOUND="YES"}
		else
		{
			HOST_NAME="N/A"
		}
	}
	VAR_INDEX++
}
}
{if (LEASE_STATE=="active" && OUTPUT_FLAG=="csv") {printf "%s,%s,%s,%s,%s,%s,%s\n", SNAP_TIME, LEASE, LEASE_END, $LEASE_TT, LEASE_STATE, MAC_ADDR, HOST_NAME}}
{if (LEASE_STATE=="active" && OUTPUT_FLAG=="json" && NR > 42) {printf ",\n"}}
{if (LEASE_STATE=="active" && OUTPUT_FLAG=="json") {printf "\t\"rec%s\":\n\t\t{\n\t\t\t\"snapTime\": \"%s\",\n\t\t\t\"lease\": \"%s\",\n\t\t\t\"leaseEnd\": \"%s\",\n\t\t\t\"leaseTT\": \"%s\",\n\t\t\t\"leaseState\": \"%s\",\n\t\t\t\"macAddress\": \"%s\",\n\t\t\t\"hostName\": %s\n\t\t}", NR, SNAP_TIME, LEASE, LEASE_END, $LEASE_TT, LEASE_STATE, MAC_ADDR, HOST_NAME}}
END {if (OUTPUT_FLAG=="json") {printf "\n}\n"}}
