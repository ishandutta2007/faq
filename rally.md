#### Rally

##### examples of queries

    (Name contains "Technical Debt")
    (Iteration.OID = "6082450599")
    (Iteration.Name = "September Sprint 2")
    (DropDownField = "")
    (Parent = null)
    ((PortfolioItem = null) AND (Parent != null))
    ((PortfolioItem != null) OR (Parent != null))
    (State < "Closed")
    (Parent.FormattedID = 18)
    ((PlanEstimate = null) AND (ScheduleState = "Defined"))
    (((PlanEstimate = null) AND (ScheduleState = "Defined")) AND (Iteration != null))
    ((ScheduleState > "Defined") AND (ScheduleState < "Accepted"))
    (Defects.ObjectID = null)
    (Defects.ObjectID != null)
    (Notes != null)
    (((Owner.UserName = "name@email.com") AND (Iteration.StartDate <= today)) AND (Iteration.EndDate >= today))
    (((ReportingCustomers > 1) and (State < "Closed")) and (Requirement = null))
    (((Owner.UserName = "name@email.com") and (State < "Closed")) and (Requirement.Name = "Story 2"))
    ((SubmittedBy.UserName = "name@email.com") and (State != "Closed"))
    ((AffectedCustomers contains "MyCustomer") AND (State != "Closed"))
    (Tags.ObjectID = null)
    (Tags.ObjectID != null)
    (((Name = "A") AND (Name = "B")) AND (Name = "C"))
    ((Tags.Name = "Tag1") AND (Tags.Name = "Tag2"))
    (Notes !contains "note1")
    ((Notes !contains "note1") OR (Notes = null))

##### general rules

When creating a custom query, remember the following:
 -  Queries require correct field names. These are found in your Web Services API documentation.
 -  Use case-sensitive field names and values such as Owner.UserName and State.
 -  Boolean field values must be in the form of True or False.
 -  When querying a custom field, include "c_", before the field name, as noted in the WSAPI documentation. For example, (c_MyCustomField = "MyCustomValue").
 -  Use a space between the field name, the operator, and the value. For example, use (Project.Name = "Acme") rather than (Project.Name="Acme").
 -  Do not use spaces in field names; for example, plan estimate should be PlanEstimate.
 -  You may only write queries that contain a field name on the left of the operator, and a value or date variable on the right side of the operator. For example, the query (CreationDate < AcceptedDate) is invalid, because both CreationDate and AcceptedDate are queryable fields listed in the Web Services API documentation.
 -  For custom field names, refer to the the Object Model listings in the Web Services API documentation.

Operators

Chain expressions cannot be linked together with operators, like this:

    ((Name contains "john") AND (Notes contains "wane") AND (Description contains "swimms")

The expression must be formed as follows (note the extra set of parentheses around the first two expressions):

    (((Name contains "john") AND (Notes contains "wane")) AND (Description contains "swimms"))


##### multiple conditions

The following is an example of how to correctly use AND with multiple ORs.
        
    Release.Name = "Release One" AND (PlanEstimate = "null" OR PlanEstimate = "1" OR PlanEstimate = "2" OR PlanEstimate = "4")

This version has been corrected to use the proper parentheses rules, but will not return all results:

    (((((Release.Name = "Release One") OR (PlanEstimate = "1")) OR (PlanEstimate = "2")) OR (PlanEstimate = "4")) AND (PlanEstimate = "null"))

Writing the query like this forces all of the OR conditions to be met first, and returns all data:

    ((((((PlanEstimate = "null") OR (PlanEstimate = "1")) OR (PlanEstimate = "4")) OR (PlanEstimate = "8")) OR (PlanEstimate = "16" )) AND (Release.Name = "Release One"))

##### parentheses rules

Two-condition query looks like this:

    ((Project.Name = "My Project") AND (Owner.UserName = "email@company.com"))

For each condition you need to put a new `(` at the beginning, and each condition after the first must end with `))`

    ((((Project.Name = "My Project") AND (Owner.UserName = "email@company.com")) AND (Iteration.Name = "2018Q1")) AND (Tags.Name = "valid"))

##### date variables

Summary

| Variable | Meaning | Timezone associated with your... | Length |
|----------|---------|----------------------------------|--------|
| Today | current date | user account | 1 day |
| Yesterday | the day before today | workspace | 1 day |
| Tomorrow | the day after today | workspace | 1 day |
| LastWeek | 7 days before today | workspace | through the end of today |
| NextWeek | 7 days after today | workspace | from the start of today |
| LastMonth | 30 days before today | workspace | through the end of today |
| NextMonth | 30 days after today | workspace | from the start of today to... |
| LastQuarter | 90 days before today | workspace | through the end of today |
| NextQuarter | 90 days today | workspace | from the start of today to... |
| LastYear | 365 days before today | workspace | through the end of today |
| NextYear | 365 days after today | workspace | from the start of the day to... |

Examples

    (LastUpdateDate = "today")
    (AcceptedDate = "yesterday")
    (LastUpdateDate >= "lastweek")
    ((PlannedStartDate >= "today") AND (PlannedStartDate <= "nextmonth"))
    ((Project.Name = "Orange Team") AND (Owner = "currentuser"))
    (AcceptedDate <= "today-7")
    (AcceptedDate < "today-7")
    (AcceptedDate >= “today-7”)
    (AcceptedDate > “today-7”)
    (AcceptedDate = “today-7”)
    (AcceptedDate != “today-7”)
    (LastUpdateDate = "today-14")
    (LastUpdateDate < "today-14")
    (LastUpdateDate = "today-60")
    (PlannedStartDate = "today + 180")
    (AcceptedDate > "2014-01-01T23:59:59.000Z")

Details

 - order: sort string, determines the order of the data returned (e.g. desc for descending order)
 - date variables are case-insensitive (e.g. "lastyear", "NEXTMONTH", "NextWeek", "Today+60")
 - white space is optional (e.g. "today-30" and "today - 30" are equivalent)
 - "today-1" and "yesterday" (and "today+1" and "tomorrow") are not equivalent. "today-1", when interpreted as a range, goes from the start of yesterday to the end of today. "yesterday", when interpreted as a range, goes only from the start of yesterday to the end of yesterday.
 - "today+0" and "today" are not equivalent. "today" is interpreted relative to the timezone associated with your user account, while "today+0" is interpreted relative to the timezone associated with your workspace.

Null Queries

To search for items with empty attribute use "null". Quotation marks are optional.

    (PlanEstimate = null)
    (Parent = "null")

When building a query against a rating or drop-down field, use a set of quotations instead:

    (Priority = "")

Note that custom drop-down fields may use either method, especially if work items were created before the custom fields.i
To ensure you capture all results, include both sets of syntax:

    ((c_CustomState = null) OR (c_CustomState = ""))


based on [document](https://docs.ca.com/en-us/ca-agile-central/saas/use-grid-app-queries)




