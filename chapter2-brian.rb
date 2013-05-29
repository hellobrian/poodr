#Calculating chainring to cog ratio

class Gear #subclass of Object
	attr_reader :chainring, :cog
	def initialize(chainring, cog)
		@chainring = chainring
		@cog = cog
	end

	def ratio
		chainring / cog.to_f
	end
end

puts Gear.new(52, 11).ratio
puts Gear.new(30, 27).ratio

#Calculating ratio with gear inches
#gear inches = wheel diameter * gear ratio
#wheel diameter = rim diameter + twice tire diameter

class Gear
	attr_reader :chainring, :cog, :rim, :tire
	def initialize(chainring, cog, rim, tire)
		@chainring = chainring
		@cog = cog
		@rim = rim
		@tire = tire
	end

	def ratio
		chainring / cog.to_f
	end

	def gear_inches
		#tire goes around rim twice for diameter
		ratio * (rim + (tire * 2))
	end
end

puts Gear.new(52, 11, 26, 1.5).gear_inches
puts Gear.new(52, 11, 24, 1.25).gear_inches

#gear_inches introduces a bug
#Gear.initialize was changed to require two additional arguments
#altering the number of arguments that a method requires
#breaks all existing callers of the method
#BUT, the application is so small that Gear.initialize currently
#has no other callers, the bug can be ignored for now

#Is this the best way to organize the code? It depends. 

class Gear
	attr_reader :chainring, :cog, :wheel
	def initialize(chainring, cog, rim, tire)
		@chainring = chainring
		@cog = cog
		@wheel = wheel
	end

	def ratio
		chainring / cog.to_f
	end

	def gear_inches
		ratio * wheel.diameter
	end

	Wheel = Struct.new(:rim, :tire) do
		def diameter
			rim + (tire * 2)
		end
	end
end

#we refactored some of our methods in the gear class
#to enforce single responsibility, methods should only do one thing
#the diameter method has to do with wheels, so we isolate it for now 
#Wheel might need its own class but we're not exactly sure yet
#SO when your friend asks for a way to calculate "bicycle wheel circumference"
#we now have more reason to create a Wheel class

class Gear
	attr_reader :chainring, :cog, :wheel
	def initialize(chainring, cog, wheel)
		@chainring = chainring
		@cog = cog
		@wheel = wheel
	end

	def ratio
		chainring / cog.to_f
	end

	def gear_inches
		ratio * wheel.diameter
	end
end

class Wheel
	attr_reader :rim, :tire

	def initialize(rim,tire)
		@rim = rim
		@tire = tire
	end

	def diameter
		rim +(tire * 2)
	end

	def circumference
		diameter * Math::PI
	end
end

@wheel = Wheel.new(26, 1.5)
puts @wheel.circumference

puts Gear.new(52, 11, @wheel).gear_inches

puts Gear.new(52, 11).ratio
