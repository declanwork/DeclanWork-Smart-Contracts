pub contract DeclanWork {
  
  //
  // Events
  //

  // Event emitted when a new gig is created
  pub event GigCreated(gigId: UInt64)

  // Event emitted when a bid is placed on a gig
  pub event BidPlaced(gigId: UInt64, bidder: Address)
  
  //
  // State
  // 

  // Freelancers struct
  pub struct Freelancer {
    pub var name: String
    pub var address: Address
    pub var portfolioURL: String
    pub var skills: [String]
    pub var categories: [String]
    pub var verified: Bool
    pub var stars: [String]

    init() {
      self.name = ""
      self.address = Address(0x0)
      self.portfolioURL = ""
      self.skills = []
      self.categories = []
      self.verified = false
      self.stars = []
    }
  } 


  pub struct GigOwner {
    pub var gigOwner: String
    pub var gigOwnerAddress: Address
    pub var isVerified: Bool
    pub var stars: [String]

    init(gigOwner: String, gigOwnerAddress: Address) {
      self.gigOwner = gigOwner
      self.gigOwnerAddress = gigOwnerAddress
      self.isVerified = false
      self.stars = []
    }

  }

  pub struct Gig {
    pub var id: UInt64
    pub var owner: Address
    pub var title: String
    pub var description: String
    pub var gigTimeline: String
    pub var deadline: Int16
    pub var budget: UFix64
    pub var featureGig: Bool
    pub var freelancer: Freelancer?
    pub var status: String
    pub var completed: Bool
    pub var escrow: UFix64

    init() {
      self.id = 0
      self.owner = Address(0x0)
      self.title = ""
      self.description = ""
      self.gigTimeline = ""
      self.budget = 0.0
      self.featureGig = false
      self.freelancer = nil
      self.status = ""
      self.deadline = 0
      self.completed = false
      self.escrow = 0.0
    }

  }


// Store the freelancers and gigs
  pub var freelancers: {Address: Freelancer}
  pub var gigOwners: {Address: GigOwner}
  pub var gigs: {UInt64: Gig}

  pub var noOfFreelancers: UInt256
  pub var noOfGigOwners: UInt256
  pub var noOfCreatedGigs: UInt256

  init() {
    self.freelancers = {}
    self.gigOwners = {}
    self.gigs = {}
    self.noOfFreelancers = 0
    self.noOfGigOwners = 0
    self.noOfCreatedGigs = 0
  }

  //
  // logic
  // 

  // Function to create a freelancer account
  pub fun createFreelancerAccount(
    name: String,
    portfolioURL: String,
    skills: [String],
    categories: [String],
    verified: Bool,
    stars: [String],
   ) {
    self.freelancers[self.account.address] = Freelancer(
      name: name,
      address: self.account.address,
      portfolioURL: portfolioURL,
      skills: skills,
      categories: categories,
      verified: verified,
      stars: stars,
    )
  }

  // Function to create a gig owner account
  pub fun createGigOwnerAccount(
    gigOwner: String,
    gigOwnerAddress: Address,
    isVerified: Bool,
    stars: [String]
  ) {
    // Perform necessary setup for gig owner account
    let newGigOwner = GigOwner(
      gigOwner: gigOwner,
      gigOwnerAddress: self.account.address,
      isVerified: isVerified,
      stars: stars,
    )
    self.gigOwners[self.account.address] = newGigOwner
  }

  // Function to create a new gig
  pub fun createGig(title: String, description: String, budget: UFix64, deadline: Date): UInt64 {
    let newGigId = self.getCurrentGigId()
    let gig = Gig(
      id: newGigId,
      owner: self.account.address,
      title: title,
      description: description,
      budget: budget,
      deadline: deadline,
      status: "open",
      freelancer: Address(0),
      completed: false
    )
    self.gigs[newGigId] = gig

    emit GigCreated(gigId: newGigId)

    return newGigId
  }

  // Function to place a bid on a gig
  pub fun placeBid(gigId: UInt64) {
    let gig = self.getGig(gigId)

    // Perform validation checks
    if (gig.status != "open") {
      revert("Gig is not open")
    }
    if (amount > gig.budget) {
      revert("Bid amount must be less than or equal to gig budget")
    }



    // Store the bid information or execute bid logic
    // Add your custom bid logic here

    emit BidPlaced(gigId: gigId, bidder: self.account.address)
  }

  // Function to confirm gig completion
  pub fun completeGig(gigId: UInt64) {
    let gig = self.getGig(gigId)

    // Perform validation checks and confirm completion
    if (gig.status != "open") {
      panic("Gig is not open")
    }

    // Transfer funds from escrow to freelancer account
    // Add your custom funds transfer logic here

    // Mark gig as completed
    gig.status = "completed"
    gig.completed = true

    gig.freelancer = self.account.address
  }

  pub fun confirmGig(gigId: UInt64) {
    let gig = self.getGig(gigId)
    if (gig.status != "completed") {
      revert("Gig is not completed")
    }
    gig.escrow = UFix64(0)
  }

  // Verify Freelancer
  pub fun verifyFreelancer(freelancerAddress: Address) {
  let freelancer = self.freelancers[freelancerAddress]
  if (freelancer.verified) {
    return
  }
  
  // if (freelancer.stars >= 5) {
  //   freelancer.verified = True
  // }

  freelancer.verified = true
}

  // Internal helper function to retrieve a gig by ID
  priv fun getGig(gigId: UInt64): &Gig {
    return self.gigs[gigId] ?? panic("Gig not found")
  }

  // Internal helper function to generate a unique gig ID
  priv fun getCurrentGigId(): UInt64 {
    // Generate and return a unique gig ID based on the current state
    // Add your custom logic to generate a unique gig ID
  }

  // Internal helper function to lock Gig payment
  priv fun lockGigPayment(gigID: UInt64) {
    let gig = self.gigs[gigID]
    if (gig.status != "completed") {
      panic("Gig is not completed")
    }

    // gig.escrow = UFix64(0)
  }


 
}