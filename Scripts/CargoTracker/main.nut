class MainClass extends GSController
{
	// Used to load saved data (currently unused)
	_load_data = null;

	// Constructor – runs once at the start of the script
	constructor()
	{
	}
}

// Helper function to get the maximum of two values
function max(x1, x2)
{
	return x1 > x2 ? x1 : x2;
}

// Called once the script is fully initialized
function MainClass::Start()
{
	this.Sleep(1); // Let the game initialize first

	this.PostInit(); // Do any setup actions here

	// Main loop – runs once per day
	while (true) {
		local loopStartTick = GSController.GetTick();

		this.HandleEvents(); // Process incoming events
		this.DoLoop();       // Your main game logic

		// Ensure consistent tick timing (1 day = 74 ticks)
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep(max(1, 74 - ticksPassed));
	}
}

// Perform setup actions like logging and placing signs
function MainClass::PostInit()
{
}

// Your custom logic that runs each loop goes here
function MainClass::DoLoop()
{
	// Example: check goal conditions, update company state, etc.
}
