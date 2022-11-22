About:
A group project that sought to create an all-in-one hiking app that allows the user to manage their hiking items into an inventory, add these items to a pack for hking or into meal plans. The user will be able to search and navigate trails across the US, while having the ability to manage meals and their pack.

How to run the project:

	Install dependencies

  	pip install -r requirements.txt
	
  Migrate data
	
    cd backend python manage.py makemigrations python manage.py migrate
  
	Create super user
     
		 python manage.py createsuperuser
 
 Run server
      
			python manage.py runserver
