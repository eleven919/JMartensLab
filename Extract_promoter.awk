#
# extract promoter regions based on custom sizes
# usage:
# awk -f add_upstream_promoter.awk file1 > promoter.txt
#


BEGIN{
	OFS="\t"
	while(getline < "/home/yi/hg19/hg19.chrom25.sizes") {
		save[$1]=$2
	}
}

(index($1, "#")==0){
	if ($6=="+") {
		start=$2-2000
		end=$2+2000
	} else {
		start=$3-2000
		end=$3+2000
	}
	
	if (start <0) {
		start=0
	}
	if (end>save[$1]) {
		end=save[$1]
	}
	print $1, start, end, $4, $5, $6
}
