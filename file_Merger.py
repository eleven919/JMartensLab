#!/usr/bin/env python


# usage: python file_Merger.py -i input -o output


# Import modules
from argparse import ArgumentParser
import os, sys
import pandas as pd

def define_options():
    #Argument parsing
    parser = ArgumentParser(description='join multiple files together and assume that the first column is in common')
    parser.add_argument('-i', '--input-files', dest="input", type=str, nargs="+", action="store", help="A list of the files to be merged.")
    parser.add_argument('-o', '--output', dest="output", type=str, action="store", default="none",help="File name of the output")
    return parser


def create_ABSpath(lst):
	#Get full path for all files
    file_lst = []
    for i in lst:
        if not os.path.isabs(i):
            fl_path = os.getcwd() + "/" + i
            file_lst.append(fl_path)
        else:
            file_lst.append(i)
    return file_lst


def merge_files(file_lst, output):
	#Select columns to be merged based on index (the first column)
    df_lst = []
    for i in file_lst:
        df = pd.read_table(i, index_col=0, header=0, usecols=[0,3], skiprows=[1,2,3], sep='\t')
        ohder = df.columns.values
        nhder = [os.path.basename(i).strip().split(".")[0] + "_" + col_id for col_id in ohder]
        df.rename(columns=dict(zip(ohder, nhder)), inplace=True)
        df_lst.append(df)

    df_merged = pd.concat(df_lst, axis=1)

    result_header = df_merged.columns.values

    with open("%s" % output, "w+") as f:
            ln = "\t".join(result_header)
            f.write(ln+"\n")

    with open("%s" % output, "a") as f:
            df_merged.to_csv(f, sep="\t", index=True, header=False, na_rep="NA")


def main():

    parser = define_options()
    
    if len(sys.argv)==1:
		parser.print_help()
		sys.exit(1)
		 
    args = parser.parse_args()

    input_list, output_name = args.input, args.output

    file_lst = create_ABSpath(input_list)

    merge_files(file_lst, output_name)


if __name__ == "__main__":
    main()
