echo 'VpcId, GroupId, GroupName, Description, TagName, From Port, To Port, Protocol, Source (IPv4), Source (IPv6), Description, From Port, To Port, Protocol, Destination, Description' > securityGroups.csv 
echo '[' > input.json
aws ec2 describe-security-groups | tail -n +3 | head -n -1 >> input.json

#Add items with tags
jq -r '.[] | select(.Tags != null) | .VpcId as $vpcid | .GroupId as $groupid | .GroupName as $groupname | .Description as $description | .IpPermissions[].FromPort as $fromport | .IpPermissions[].ToPort as $toport | .IpPermissions[].IpProtocol as $ipprotocol | .IpPermissions[].IpRanges[].CidrIp as $sourceipv4 | .IpPermissions[].Ipv6Ranges[].CidrIpv6 as $sourceipv6 | .IpPermissions[].IpRanges[].Description as $ipv4description | .IpPermissionsEgress[].FromPort as $outfromport | .IpPermissionsEgress[].ToPort as $outtoport | .IpPermissionsEgress[].IpProtocol as $outprotocol | .IpPermissionsEgress[].IpRanges[].CidrIp as $ipv4outbound |.IpPermissionsEgress[].IpRanges[].Description as $outdescription |.Tags[].Key as $key | ([$vpcid, $groupid, $groupname, $description, $key ,$fromport, $toport, $ipprotocol, $sourceipv4, $sourceipv6, $ipv4description, $outfromport, $outtoport, $outprotocol,$ipv4outbound, $outdescription] | @csv)' input.json | sort -u >> securityGroups.csv


