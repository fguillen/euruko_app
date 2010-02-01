# The EuRuKo Conf 2010 Application

Handles Euruko 2010 site and allows to register to both attendees and speakers and pay registration fee.

## Setup

Make sure you have bundler gem installed:

    gem install bundler
    
## Step by Step

These are the steps to put up the application with fake data:

    git clone git://github.com/bragi/euruko_app.git
    cd euruko_app
    gem install bundler             # or sudo gem install bundler
    gem bundle
    cp certs/app_cert.pem_example certs/app_cert.pem
    cp certs/app_key.pem_example certs/app_key.pem
    cp certs/paypal_cert.pem_example certs/paypal_cert.pem
    rake init:all db=sqlite

Got to
    http://localhost:3000
    
Login as admin using:
    login: admin
    pass: adminpass
    email: admin@email.com
    
Login as user using:
    login: newton
    pass: consequunturvoluptatemquae
    email: litzy@hotmail.com

    
## Details

The application uses Paypal payment implementing the Ryan's Paypal Tutorial:

* http://railscasts.com/episodes/141-paypal-basics
* http://railscasts.com/episodes/142-paypal-notifications
* http://railscasts.com/episodes/143-paypal-security

So better take a look to these screencasts.

### Configuration
Review the:
    config/config.yml
    
### Certs

Create the certs:
    certs/app_cert.pem
    certs/app_key.pem

Download you paypal cert:
    certs/paypal_cert.pem
    
View the [Ryan's Paypal certs screen cast](http://railscasts.com/episodes/143-paypal-security)

## Deploy on production

Three differences between development and production:

* Better use mysql instead of sqlite
* Not charge the fake data
* Using real certs

### Step by Step on production

#### Clone
    git clone git://github.com/bragi/euruko_app.git
    cd euruko_app
    
#### The Bundler Gem
    cd euruko_app
    gem install bundler             # or sudo gem install bundler
    gem bundle
    
#### Configuration
    rake init:config_files db=mysql user=euruko password=euruko

##### Review Configuration
* **site_domain** Your production domain, used on static urls like email urls. ej: euruko2010.org
* **site_name** ej: EuRuKo2010
* **email_sender** ej: EuRuKo <info@euruko2009.org>
* **email_notification_recipients**  Array with the emails to receive app notifications. ej: [fguillen.mail@gmail.com,pepe@pepe.com]
* **paypal_url** normally: https://www.paypal.com/cgi-bin/webscr
* **paypal_seller** paypal username. ej: myuser@gmail.com
* **paypal_cert_id** paypal cert id. ej: Z954BH8ATL6XC
* **paypal_secret** paypal communication secret word, used like seed, any value is ok. ej: my_paypal_secret
* **yahoo_id** the yahoo id. Used on the user profile form for city autocompletion. Look on: [https://developer.apps.yahoo.com/wsregapp/](https://developer.apps.yahoo.com/wsregapp/)
* **twitter_user** Used on a script that twitts how many tickets are left. The script is turned off.
* **twitter_pass** Used on a script that twitts how many tickets are left. The script is turned off.
* **twitter_notification_step** Used on a script that twitts how many tickets are left. The script is turned off.
* **tax_percent** This is the TAX of the tickets. Used on the invoice creating. ej: 16
* **seller_invoice_info** Used on the invoice creation, is the Seller invoice info.
* **invoices_pdf_path** Relative path to the root directory where the invoices PDFs will be stored. ej:  /public/invoices
* **invoices_serial_prefix** Serial prefix for the invoices numbers. ej: euruko-2010-
    

#### Init Databases
    mysql -uroot

    mysql> create database euruko_development;
    mysql> grant all privileges on euruko_development.* to euruko@localhost identified by 'euruko';
    mysql> create database euruko_test;
    mysql> grant all privileges on euruko_test.* to euruko@localhost identified by 'euruko';
    mysql> create database euruko;
    mysql> grant all privileges on euruko.* to euruko@localhost identified by 'euruko';
    mysql> exit;

    rake db:migrate RAILS_ENV=production
    rake db:migrate RAILS_ENV=development
    rake db:migrate RAILS_ENV=test
    
#### The Certificates
View the [Ryan's Paypal certs screen cast](http://railscasts.com/episodes/143-paypal-security)

Create the local certs and upload the public key to Paypal.

Download your Paypal user's certificate.

All the certs are on the **/certs** folder.

#### Runt Tests
    rake
    
#### Create Admin account
    rake populate:admin RAILS_ENV=production
    
## Start to fill the application

Always logged as admin.

As Admin you have a special menu on your right.


#### The Events
The application support multi events. So you can sell tickets for more than one event on the Conference. Like the Conference and a workshop, or a dinner, or whatever.

Got to **Events** menu > **Create New Event**

Fill the form, remember that the price **should be on cents**, so 50 euros will be 5000 cents.

#### The Rooms
If there are multiple scenarios you can create them and associate each Talk to its Room.

Always have to be at least one Room.

#### The Talks.
The talks could be created by an Admin but the app is prepared to allow the users to send their own proposes of talks.

The users should go to the registration form, register him self and use the **Submit Talk** to offer his proposal of talk.

You as Admin can see all the Talks even if they are not on 'Accepted' status. The normal users only could see the Talks on 'Accepted' status.

It is very recommended to ask to the users to propose their own Talks because they can submit their own description, picture and resources.

##### Speakers
As the Talk is submitted the user in session will be the principal speaker of the Talk.

Any speaker of the Talk or an Admin could add speakers or delete using the Edit form.

Only the users with 'Public profile' will appear here so if any user want to be a speakers it should have a 'Public profile'.

##### Picture
The Edit form allow to submit a picture of the Talk.

##### Resources
The Edit form allow to submit urls or upload files as extra resources for the talk.

##### Status
Any Admin could change the status of the Talk, only the Talks on 'Accepted' status will appear on the Calendar view.

##### Family
The talk could be a session, or a workshop, etc.

There is an special family: 'break' it is like a hack so in the Calendar view the breaks will appear too.

##### Date
Is important all the 'Accepted' Talks to have a Date and Time or the Calendar View will break down.. (it is a thing to fix).

If in the edit form you don't offer a Time the Date will be not stored.. (another thing to fix).

##### Room
The Talk have to be associated a Room or the Calendar view will break down. (another thing to fix).


#### The Calendar
If there is not any Talk accepted the Calendar will show 'Comming soon...'

The Calendar will show all the Talks on 'Accepted' status.

It is important all the Talks on 'Accepted' status to have:

* Date
* Time
* Room


#### The People
All the users registered on the application.

Only the users that have mark on his profile the 'Public profile' check will be appear here. If an Admin is logged he will see all the Users inclusive the not 'Public profiles'.


##### Show All
All the Users registered

##### Show Attendees
This is a hack.. all the Users that have paid the Event with id == 1 will appear on this list.

As usual only the 'Public profile' will be shown for the users not Admin.

See the '/app/views/users/index.html.erb' to see this menu and adapt it to your needs.


##### Show Speakers
All the users associated to a Talk on 'Accepted' status will appear in this list.

If an Admin is logged he will see all the users associated to a Talk even the Talk is no on 'Accepted' status.

##### Exports
All the lists could be exported to: 

* xml
* pdf
* csv

Look the links at the end of the lists.

#### Payments
This is important to be checked very carefully.

The best way to check this is one time you have the app on production you can create an Event with a cost of 1 euro (100 cents), for example, and try to pay for it.

You always can go to the seller paypal account and refund this payment.

On the menu 'Payments' you can see all the carts (like the cart on any kind of online store) but all the carts on status 'On session' don't mean anything it is just for debugging.

The important status are:

##### Completed
What means the payment has been accepted.

##### Not Notified by PayPal
Very strange status that means the user have gone to paypal but paypal has not notified us.

##### PayPal Error
Very important to check what have happened in here.

##### Refunds
Paypal allows to refund any payment.

The application is not prepared to support refunds so the refunds you have to do it by hand through Paypal website.

The process of refunds is a little annoying.

You have to go to Paypal to make the refund.

You have to modify the status of the Cart instance you are refunding to change its status.

You will see a 'Paypal Error' on this Cart because the Paypal will notify to our app of the refund but our application won't accept that signal.

#### Pages
You can create static pages as:

* Help
* How to arrive
* Payments instructions
* FAQ 

Use your admin menu to access to the Pages.

The Description on the edit form admit MarkDown format.

The links to this pages will appear on the menu.


#### Invoices
The invoices will be created on demand.

The users could access to his profile and see all the purchases he has done. He can access to the detail of these purchases and create or download the invoice.

You have to configure the seller invoice info on the config/config.yml:

    seller_invoice_info: "Spanish Ruby Users Group \nTravessera de les Corts 48, Sobreático 2a \n08903 L'Hospitalet de Llobregat \nBarcelona (Spain) \nG65037772"
    
You have to configure the TAX of the invoice on the config/config.yml:

    tax_percent: 16

The place where the PDFs will be stored:

    invoices_pdf_path:  /public/invoices
    
And the serial prefix for the invoices numeration:
    
    invoices_serial_prefix: euruko-2009-
    
Using this serial prefix the invoices will be numbered like this:

* euruko-2009-001
* euruko-2009-002
* euruko-2009-003
* ...



## Rake tasks
See the /lib/tasks there are a few utile tasks for development.

## SMTP
The email sending is configured to use :sendmail is better to configure to use :smtp but this is not implemented.
