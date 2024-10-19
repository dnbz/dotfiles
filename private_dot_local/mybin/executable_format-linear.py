#!/usr/bin/python3
import pandas as pd
import argparse

def main():
    # Set up the argument parser
    parser = argparse.ArgumentParser(description='Filter a CSV file to only include certain columns and rows with a specific assignee.')
    parser.add_argument('file_name', type=str, help='The path to the CSV file')
    parser.add_argument('--assignee', type=str, help='The email to filter the Assignee column by')

    # Parse the arguments
    args = parser.parse_args()

    # Load the CSV file
    df = pd.read_csv(args.file_name)

    # Filter rows where Assignee equals the provided email
    if args.assignee:
        df['Assignee'] = df['Assignee'].str.strip()  # Trim spaces
        df = df[df['Assignee'].str.lower() == args.assignee.lower().strip()]

    # Columns to keep, hardcoded
    columns_to_keep = ['ID', 'Title', 'Description', 'Status', 'Priority', 'Assignee', 'Labels', 'Created', 'Completed']

    # Select only the specified columns
    final_df = df[columns_to_keep]

    # Save the result back to CSV
    output_file = 'filtered-' + args.file_name
    final_df.to_csv(output_file, index=False)
    print(f'Output saved to {output_file}')

if __name__ == '__main__':
    main()
