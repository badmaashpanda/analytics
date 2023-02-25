-- SMS Confirmations From Users
-- Meta/Facebook sends SMS texts when users attempt to 2FA (2-factor authenticate) into the platform to log in. In order to successfully 2FA they must confirm they received the SMS text message. Confirmation texts are only valid on the date they were sent.

-- Unfortunately, there was an ETL problem with the database where friend requests and invalid confirmation records were inserted into the logs, which are stored in the 'fb_sms_sends' table. These message types should not be in the table.

-- Fortunately, the 'fb_confirmers' table contains valid confirmation records so you can use this table to identify SMS text messages that were confirmed by the user.

-- Calculate the percentage of confirmed SMS texts for August 4, 2020.

select 100*sum(case when b.phone_number is null then 0 else 1 end)/count(a.phone_number)::float
from fb_sms_sends a
left join fb_confirmers b on a.ds=b.date and a.phone_number=b.phone_number
where a.ds = '2020-08-04'
and type = 'message'