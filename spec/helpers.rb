def fake_login_user(user = jay_pivot)
	session[:google_id] = user.google_id
end

def fake_logged_in_user
	User.find_by_google_id(session[:google_id])
end

def login_user(user = jay_pivot)
	GoogleApiInterface.any_instance.stub(:authorize_from_code).with("code")
	GoogleApiInterface.any_instance.stub(:current_user_google_id).and_return(user.google_id)
	GoogleApiInterface.any_instance.stub(:current_user_email).and_return(user.email)
	GoogleApiInterface.any_instance.stub(:image_url_for_user).with(user.google_id).and_return(user.profile_image_url)
	GoogleApiInterface.any_instance.stub(:display_name_for_user).with(user.google_id).and_return(user.display_name)
	
	visit '/google_auth_callback?code=code'
	
	@logged_in_user = user.reload
end

def logged_in_user
	@logged_in_user
end

def jay_pivot
	User.find_by_email("testing.pair.exchange@gmail.com") ||
	User.create(
		email: "testing.pair.exchange@gmail.com", 
		google_id: '108496684470619075074',
		profile_image_url: "https://lh6.googleusercontent.com/-2f9n0FXNPxo/AAAAAAAAAAI/AAAAAAAAABA/G01vbPsCRn8/photo.jpg?sz=50",
		display_name: "Jay Pivot"
	)
end

def friendly_user
	User.find_by_email('pear.programming@gmail.com') ||
		User.create(email: 'pear.programming@gmail.com', google_id: '116917872107923397489')
end

def loner
	User.find_by_email('o.solo.mioooo@gmail.com') ||
		User.create(email: 'o.solo.mioooo@gmail.com', google_id: '117952378088929416951')
end

