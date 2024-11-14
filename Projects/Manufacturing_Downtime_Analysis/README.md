<h2>Manufacturing Downtime Analysis</h2>

Identify productivity improvement opportunities in a production line.

<h4>The Data Set</h4>

Productivity & downtime data for a soda bottling production line, including information on the operator, product, start & end times, and dowtime factors for each batch.

<b>Recommended Analysis:</b>

 - What's the current line efficiency? (total time / min time)
 - Are any operators underperforming?
 - What are the leading factors for downtime?
 - Do any operators struggle with particular types of operator error?

<h4>Objective 1 - Calculate line efficiency</h4>

Your first objective is to calculate the efficiency for a production line and break it down by operator.

<b>Task</b>

 - Create a new "Batch time" column in the "Line Productivity" tab that calculates the minutes between the "Start time" and "End time"
 - Create a new "Min batch time" column by looking up the value from the "Products" tab
 - Calculate the "Efficiency" (sum of "Min batch time" / sum of "Batch time") for each operator
 - Visualize the data using a bar chart
 - Use the chart title and formatting to make a recommendation

<h4>Objective 2 - Identify main downtime factors</h4>

Your second objective is to use a Pareto chart to identify the main factors for downtime in the production line.

<b>Task</b>

 - Create a "Downtime" column in the "Downtime factors" tab that sums the downtime for each factor from the "Line downtime" tab
 - Sort the factors in descending order by downtime
 - Create a "Pareto" column that calculates the % running total of downtime for each factor
 - Create a Pareto chart for the downtime factors
 - Use the chart title and formatting to make a recommendation

<h4>Objective 3 - Calculate downtime by operator & factor</h4>

Your final objective is to use a matrix to calculate the total downtime by operator for each of the main factors you identified.

<b>Task</b>

 - Create a matrix with the operators as the rows and the main downtime factors as the columns
 - Add an "Operator" column to the "Line downtime tab" and look up the values for each batch
 - Calculate the total downtime for each operator by factor
 - Apply conditional formatting to highlight main downtime factors by operator
 - Use the chart title and formatting to make a recommendation

<h4>Final Step - Final Project Question</h4>

Answer the following question to validate your completed project.

 - How much downtime did Dee cause due to machine adjustments? (in minutes)
