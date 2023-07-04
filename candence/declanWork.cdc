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

    init(name: String, address: Address, portfolioURL: String, skills: [String], categories: [String], verified: Bool, stars: [String]) {
      self.name = name
      self.address = address
      self.portfolioURL = portfolioURL
      self.skills = skills
      self.categories = categories
      self.verified = verified
      self.stars = stars
    }
  } 


  pub struct GigOwner {
    pub var gigOwner: String
    pub var gigOwnerAddress: Address
    pub var isVerified: Bool
    pub var stars: [String]

    init(gigOwner: String, gigOwnerAddress: Address, isVerified: Bool, stars: [String]) {
      self.gigOwner = gigOwner
      self.gigOwnerAddress = gigOwnerAddress
      self.isVerified = isVerified
      self.stars = stars
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
    pub var status: String?
    pub var completed: Bool
    pub var escrow: UFix64

    init(id: UInt64, owner: Address, title: String, description: String, gigTimeline: String, deadline: Int16, budget: UFix64, featureGig: Bool, freelancer: Freelancer?, status: String?, completed: Bool, escrow: UFix64) {
      self.id = id
      self.owner = owner
      self.title = title
      self.description = description
      self.gigTimeline = gigTimeline
      self.budget = budget
      self.featureGig = featureGig
      self.freelancer = freelancer
      self.status = status
      self.deadline = deadline
      self.completed = completed
      self.escrow = escrow
    }

  }


// Store the freelancers and gigs
  pub var freelancers: {Address: Freelancer}
  pub var gigOwners: {Address: GigOwner}
  pub var gigs: {UInt64: Gig}

  pub var noOfFreelancers: UInt64
  pub var noOfGigOwners: UInt64
  pub var noOfCreatedGigs: UInt64

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
      verified: false,
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
  pub fun createGig(title: String, description: String, budget: UFix64, deadline: Date, gigTimeline: String, featureGig: Bool, freelancer: Freelancer?, status: String, completed: Bool, escrow: UFix64): UInt64 {
    let newGigId = self.getCurrentGigId()
    let gig = Gig(
      id: newGigId,
      owner: self.account.address,
      title: title,
      description: description,
      gigTimeline: gigTimeline,
      deadline: deadline,
      budget: budget,
      featureGig: featureGig,
      freelancer: freelancer,
      status: status,
      completed: completed,
      escrow: escrow
    )
    self.gigs[newGigId] = gig

    emit GigCreated(gigId: newGigId)

    return newGigId
  }

  // Function to place a bid on a gig
  pub fun placeBid(gigId: UInt64, amount: UFix64) {
    let gig = self.getGig(gigId: gigId)

    // Perform validation checks
    if (gig.status != "open") {
      panic("Gig is not open")
    }
    if (amount > gig.budget) {
      panic("Bid amount must be less than or equal to gig budget")
    }



    // Store the bid information or execute bid logic
    // Add your custom bid logic here

    emit BidPlaced(gigId: gigId, bidder: self.account.address)
  }

  // Function to confirm gig completion
  pub fun completeGig(gigId: UInt64) {
    let gig = self.getGig(gigId: gigId)

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
    let gig = self.getGig(gigId: gigId)
    if (gig.status != "completed") {
      panic("Gig is not completed")
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
  // pub fun getGig(gigId: UInt64): Gig {
  // let gig = self.gigs[gigId]
   // if let gig = gig as? Gig {
   //     return gig
   // } else {
   //     return panic("Gig not found")
   // }
   // return self.gigs[gigId] ?? panic("Gig not found")
  // }

  pub fun getGig(gigId: UInt64): Gig {
    let gig = self.gigs[gigId] ?? panic("Gig not found")
    return gig
  }

  // Internal helper function to generate a unique gig ID
  pub fun getCurrentGigId(): UInt64 {
      return noOfCreatedGigs

    // Generate and return a unique gig ID based on the current state
    // Add your custom logic to generate a unique gig ID
  }

  // Internal helper function to lock Gig payment
  pub fun lockGigPayment(gigId: UInt64) {
    let gig = self.getGig(gigId: gigId)
    if (gig.status != "completed") {
      panic("Gig is not completed")
  }

    // gig.escrow = UFix64(0)
  }


 
}