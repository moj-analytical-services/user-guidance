# Common Issues and Troubleshooting

### Issue: Unable to see a dataset in QuickSight

- Ensure you have the necessary permissions to access the dataset.
- Verify that the dataset is within the `mojap-derived-table` domains.
- Check if the dataset is available via the `Athena` data source.

See [this question in FAQs](/tools/quicksight/faqs.html#how-do-i-know-if-i-should-be-able-to-see-a-particular-tabledatabasedomain-in-quicksight) for more information

### Issue: Slow dashboard performance

- Optimize your queries
  - Remove unnecessary data from queries
  - Optimise joins and data structure
- Check out [the QuickSight optimisation tips page] for specific tips
- Load data into SPICE

### Issue: Error while importing data

- Check the data format and structure
  - Can you read and query the data via the Athena console (in the Ireland region within the data account) or via `boto3`/`pydbtools`?
- Ensure the data source is correctly configured in QuickSight (see [Finding datasets](/tools/quicksight/03-working-with-quicksight.html#finding-datasets))
- [Raise a support request] providing details of the problem and what you've tried.

<!-- External links -->

[the QuickSight optimisation tips page]: https://aws.amazon.com/blogs/big-data/tips-and-tricks-for-high-performant-dashboards-in-amazon-quicksight/
[Raise a support request]: https://github.com/ministryofjustice/data-platform-support/issues/new/choose
