class User 

	#By Parker Griep

	attr_accessor :username, :birthday, :name, :age, :gender, :relationship_status, :password, :poked, :initialized

	def initialize(username, password)
		@username = username
		@password = password
		@initialized = false
		@statuses = []
		@friends = []
	end

	def account_initialize(name, age, birthday, gender, relationship_status)
 		@name = name
 		@age = age
 		@birthday = birthday
 		@gender = gender
 		@relationship_status = relationship_status
 		@initialized = true
 	end

	#----Info----
	def info
		rtn = "\n"
		rtn += "Name       : #{@name}\n"
		rtn += "Age        : #{@age}\n"
		rtn += "Birthday   : #{@birthday}\n"
		rtn += "Gender     : #{@gender}\n"
		rtn += "Rel-Status : #{@relationship_status}"
		rtn
	end

	#----Wall----
	def add_to_wall(status) @statuses.unshift(status.to_s)  
	end

	def remove_from_wall()
		@statuses.delete_at(0)
	end

	def wall
		rtn = "\n"
		@statuses.each do |status|
			rtn += status + "\n"
		end
		return rtn 
	end

    #----Friends---- 
	def add_friend(user) @friends << user end

	def remove_friend(user) 
		@friends.delete(user)
		@friends.compact!
	end

	def friends
		rtn = "\n"
		@friends.each do |f|
			rtn += "#{f.name}\t#{f.username}"
		end
		return rtn
	end

	def check_friends(user)
		@friends.include?(user)
	end

	def poke(user)
	 	if check_friends(user)
	 		user.poked=(true)
	 		puts "You poked #{user.name}"
	 	else
	 		puts "You aren't friends with that User!"
	 	end
	end

	def friends_wall(user)
		if check_friends(user)
			user.wall
		else
			puts "You aren't friends with that User!"
		end
	end

	def friends_info(user)
		if check_friends(user)
			user.info
		else
			puts "You aren't friends with that User!"
		end
	end
end

class UserDatabase

	def initialize

		#STOCK USERS
		darth_vader = User.new("darth vader", "1234")
		darth_vader.account_initialize("Anakin Skywalker", 37, "1/5/1978", "sithlord", "widowed")
		darth_vader.add_to_wall("I love Pod-Racing")
		darth_vader.add_to_wall("Just joined the Dark Side!")
		darth_vader.add_to_wall("Force Choking is co--")
		darth_vader.add_to_wall("My son is a good jedi, you guys should give him a hand")

		einstein = User.new("einstein", "1234")
		einstein.account_initialize("Albert Einstein", 45, "3/14/1879", "male", "single")
		einstein.add_to_wall("I'm a pretty smart guy")
		einstein.add_to_wall("E = mc^2")
		einstein.add_to_wall("Zufalls Deutsch Wörter")

		terminator = User.new("terminator", "1234")
		terminator.account_initialize("Arnold Schwarz",67,"6/30/1947", "robot", "?????")
		terminator.add_to_wall("I lift things up and put them down")
		terminator.add_to_wall("Hasta la Vista Baby")
		terminator.add_to_wall("You're looking at the governor of California")
		terminator.add_to_wall("I'll be back")

		user_list = {
			darth_vader.username => darth_vader,
			einstein.username => einstein,
			terminator.username => terminator}
		db_commands = ["help","login","signup","clear","quit"]
		user_commands = ["help","logout","init","clear","self","users","friends","add","remove","status","rm status","wall","info","poke"]

		loop do
			selected = "self"
			quit = false
			log = false

			puts "\nWelcome to Parker_Social! (Type \"help\" for help)\n"
			db_input = gets.chomp!
			case db_input
			when "help"
			    puts "\n"
				puts db_commands
			when "clear"
				puts "\n" * 25
			when "quit"
				quit = true
			when "signup"
				puts "Enter a username"
				username = gets.chomp!
				puts "Enter a password"
				password = gets.chomp!
				user_list[username] = User.new(username, password)

			when "login"
				puts "Enter your username"
				username = gets.chomp!
				puts "Enter your password"
				password = gets.chomp!

				if user_list.include?(username)
					if user_list[username].password == password
						u = user_list[username]
						log = true
					end
				end 
			else
				puts "#{db_input} is not a registered command!"
			end

			while log
				puts "\nYou are in Parker_Social (Type \"help\" for help)"
				puts "Selected | #{selected}\n"
				input = gets.chomp!
				case input
				when "help"
					puts "\n"
					puts user_commands
				when "logout"
					puts "\nGoodbye!"
					log = false
				when "clear"
					puts "\n" * 25
				when "self"
					selected = "self"
				when "users"
					puts "\n"
					user_list.each_key do |user|
						puts user
					end
					puts "\nPlease select a User by typing their name"
					temp = gets.chomp!
					selected = temp if user_list.has_key?(temp)
				when "init"
					puts "\nEnter your full name"
					name = gets.chomp!
					puts "Enter your age"
					age = gets.chomp!
					puts "Enter your birthday(mm,dd,yyyy)"
					birthday = gets.chomp!
					puts "Enter your gender"
					gender = gets.chomp!
					puts "Enter your relationship status"
					relationship_status = gets.chomp!
					u.account_initialize(name, age, birthday, gender, relationship_status)
				when "friends"
					puts "\n"
					puts u.friends
				when "add"
					if u.initialized
						puts "\n"
						if selected == "self"
							puts "Can't friend yourself"
						else 
							u.add_friend(user_list[selected])
							puts "You are now friends with #{user_list[selected].name}!"
						end
					else
						puts "You need to initialize your account before you can do that!"
					end
				when "remove"
					if selected == "self"
						puts "Can't unfriend yourself"
					else
						u.remove_friend(user_list[selected])
					end
				when "status"
					if u.initialized
						puts "Enter a new status:"
						u.add_to_wall(gets.chomp)
					else
						puts "You need to initialize your account before you can do that!"
					end
				when "rm status"
					if u.initialized
						u.remove_from_wall
					else
						puts "You need to initialize your account before you can do that!"
					end
				when "wall"
					if u.initialized
							if selected == "self"
								puts u.wall
							else
								puts user_list[selected].wall
							end
					else
						puts "You need to initialize your account before you can do that!"
					end
				when "info"
					if u.initialized
							if selected == "self"
								puts u.info
							else
								puts user_list[selected].info
							end
					else
						puts "You need to initialize your account before you can do that!"
					end
				when "poke"
					if u.initialized
						if selected == "self"
							puts "You can't poke yourself"
						else
							u.poke(user_list[selected])
						end
					else
						puts "You need to initialize your account before you can do that!"
					end
				else
				end
			end
			
			break if quit
		end
	end
end

UserDatabase.new()