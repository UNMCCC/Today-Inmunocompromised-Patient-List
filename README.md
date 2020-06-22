Today Immunocompromised Patient List
====================================

At the UNM Comprehensive Cancer Center, the providers, nurses and staff need to
pay special attention to those patients who are currently immunocompromised. To
that end, the first and foremost important thing is that the team understand
which patients maybe coming each day with a compromised immune system.

In the past, our Electronic Health System (Mosaiq) provided an indirect report
on Alerts created in the system. The nurses have to run said report manually to
gather this simple piece of information: who is coming, when where. This is too
time consuming.

We present here the main pieces that automated EHS data extraction regarding
current immunocompromised patients. We ask Tableau to deliver this list
automatically to subscribers each morning, with a link to the list, with data
refreshed throughout the day automatically.

To make this system work, a Mosaiq administrator would have to configure a type
of alert as immunocompromised. The nurse and staff teams will have to use the
alert system to annotate which patient has the condition, and make the alert
active. Using the SQL code provided here, we extract the list of
immunocompromised patients from the system for today. We automate the extract to
run 10 times a day, every hour, during most active hours.

We stage the extracted data for the Tableau visualization software, which
renders an easy to read list and distributes it to the subscribers.
