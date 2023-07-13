pub contract Declan {
  
  //
  // Events
  //

  // Event emitted when a new gig is created
  pub event GigCreated(gigId: UInt64)

  // Event emitted when a bid is placed on a gig
  pub event BidPlaced(gigId: UInt64, bidder: Address)

   // Event emitted when a bid is placed on a gig
  pub event FreelancerJoined(freelancer: Address)

  pub event AcceptBid(gigId: UInt64, freelancer: Address)
  
  //
  // State
  // 

  // Freelancers struct
  pub struct Freelancer {
    pub(set) var name: String
    pub(set) var address: Address
    pub(set) var portfolioURL: String
    pub(set) var skills: [String]
    pub(set) var categories: [String]
    pub(set) var verified: Bool
    pub(set) var stars: UInt32
    pub(set) var email: String
    pub(set) var country: String
    pub(set) var jobCount: UInt32

    init(name: String, address: Address, portfolioURL: String, skills: [String], categories: [String], verified: Bool, stars: UInt32, email: String, country: String,jobCount: UInt32) {
      self.name = name
      self.address = address
      self.portfolioURL = portfolioURL
      self.skills = skills
      self.categories = categories
      self.verified = verified
      self.stars = stars
      self.email= email
      self.country= country
      self.jobCount= jobCount
    }
  } 


  pub struct GigOwner {
    pub(set) var gigOwner: String
    pub(set) var gigOwnerAddress: Address
    pub(set) var gigOwnerCompany: String
    pub(set) var isVerified: Bool
    pub(set) var stars: UInt32

    init(gigOwner: String, gigOwnerAddress: Address, gigOwnerCompany: String, isVerified: Bool, stars: UInt32) {
      self.gigOwner = gigOwner
      self.gigOwnerAddress = gigOwnerAddress
      self.isVerified = isVerified
      self.gigOwnerCompany = gigOwnerCompany
      self.stars = stars
    }

  }

  pub struct Gig {
    pub(set) var id: UInt64
    pub(set) var owner: Address
    pub(set) var ownerEmail: String
    pub(set) var freelancer: Address
    pub(set) var title: String
    pub(set) var description: String
    pub(set) var gigTimeline: UInt64
    pub(set) var deadline: UInt64
    pub(set) var budget: UInt64
    pub(set) var featureGig: Bool
    pub(set) var bidders: {Address: Bidder?}
    pub(set) var status: String
    pub(set) var escrower: Address
    pub(set) var escrowAmount: UInt64
    pub(set) var warningCount: UInt64

    init(id: UInt64, owner: Address, ownerEmail: String, freelancer: Address, title: String, description: String, gigTimeline: UInt64, deadline: UInt64, budget: UInt64, featureGig: Bool, bidders: {Address: Bidder?},  status: String, escrower: Address, escrowAmount: UInt64, warningCount: UInt64) {
      self.id = id
      self.owner = owner
      self.ownerEmail= ownerEmail
      self.freelancer = freelancer
      self.title = title
      self.description = description
      self.gigTimeline = gigTimeline
      self.deadline = deadline
      self.budget = budget
      self.featureGig = featureGig
      self.bidders = bidders
      self.status = status
      self.escrowAmount = escrowAmount
      self.escrower = escrower
      self.warningCount = warningCount
    }

  }

  // bidder struct
  pub struct Bidder {
    pub var freelancerName: String
    pub var freelancerSkills: [String]
    pub var freelancerPortfolioURL: String
    pub var bidAmount: UInt64

    init(freelancerName: String, freelancerSkills: [String], freelancerPortfolioURL: String, bidAmount: UInt64) {
      self.freelancerName = freelancerName
      self.freelancerSkills = freelancerSkills
      self.freelancerPortfolioURL = freelancerPortfolioURL
      self.bidAmount = bidAmount
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
    address: Address,
    portfolioURL: String,
    skills: [String],
    categories: [String],
    verified: Bool,
    stars: UInt32,
    email: String,
    country: String,
    jobCount: UInt32,
   ) {
    self.freelancers[address] = Freelancer(
      name: name,
      address: address,
      portfolioURL: portfolioURL,
      skills: skills,
      categories: categories,
      verified: verified,
      stars: stars,
      email: email,
      country: country,
      jobCount: jobCount,
    )

    emit FreelancerJoined(freelancer: self.account.address)
  }

  // Function to create a gig owner account
  pub fun createGigOwnerAccount(
    gigOwner: String,
    gigOwnerAddress: Address,
    gigOwnerCompany: String,
    isVerified: Bool,
    stars: UInt32
  ) {
    // Perform necessary setup for gig owner account
    let newGigOwner = GigOwner(
      gigOwner: gigOwner,
      gigOwnerAddress: self.account.address,
      gigOwnerCompany: gigOwnerCompany,
      isVerified: isVerified,
      stars: stars,
    )
    self.gigOwners[gigOwnerAddress] = newGigOwner
  }

  // Function to create a new gig
  pub fun createGig(owner:Address, ownerEmail: String, title: String, description: String, gigTimeline: UInt64, budget: UInt64): UInt64 {
    // Get the current gig ID
    let newGigId = self.getCurrentGigId()

    // Create a new gig struct with the specified values
    let gig = Gig(
      id: newGigId,
      owner: owner,
      ownerEmail: ownerEmail,
      freelancer: owner,
      title: title,
      description: description,
      gigTimeline: gigTimeline,
      deadline: 0,
      budget: budget,
      featureGig: false,
      bidders: {},
      status: "open",
      escrower: owner,
      escrowAmount: 0,
      warningCount: 0,
    )
    self.gigs[newGigId] = gig

    emit GigCreated(gigId: newGigId)
    
    // To generate update noOfCreatedGigs counter
    self.noOfCreatedGigs = self.noOfCreatedGigs + 1

    return newGigId
  }

  // Function to place a bid on a gig
  pub fun placeBid(gigId: UInt64, bidAmount: UInt64) {
    let gig = self.getGig(gigId: gigId)

    // Perform validation checks
    if (gig.status != "open") {
      panic("Gig is not open")
    }
    if (bidAmount > gig.budget) {
      panic("Bid amount must be greater than or equal to gig budget")
    }

    // Retrieve the bidder's information from the freelancers dictionary
    let bidderAddress = self.account.address
    let freelancer = self.freelancers[bidderAddress]
    if freelancer == nil {
      panic("Freelancer not found")
    }

    // Store the bid information
    let bidder = Bidder(
      freelancerName: freelancer!.name,
      freelancerSkills: freelancer!.skills,
      freelancerPortfolioURL: freelancer!.portfolioURL,
      bidAmount: bidAmount
    )
    gig.bidders[bidderAddress] = bidder
    gig.status = "bid_placed"

    emit BidPlaced(gigId: gigId, bidder: bidderAddress)
  }

  //Function to accept a freelancer bid
   // Function to place a bid on a gig
  pub fun acceptBid(gigId: UInt64,bidAmount: UInt64, freelancer: Address, escrower: Address) {
    let gig = self.getGig(gigId: gigId)

    // Perform validation checks
    if (gig.status == "WIP") {
      panic("Gig has a freelancer working on it already")
    }
    
    gig.freelancer = freelancer

    gig.deadline = gig.deadline + gig.gigTimeline

    gig.escrowAmount = bidAmount

    gig.escrower = escrower

    gig.status = "WIP"

     // Transfer the budget amount to the escrow account
    // escrower.deposit(gig.budget)

    emit AcceptBid(gigId: gigId, freelancer: freelancer)

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

  }

  pub fun confirmGig(gigId: UInt64) {
    let gig = self.getGig(gigId: gigId)
    if (gig.status != "completed") {
      panic("Gig is not completed")
    }

    gig.status = "confirm"

    // Transfer funds from escrow to freelancer account
    // Add your custom funds transfer logic here
  }

  pub fun ExtendDeadline(gigId: UInt64, newDeadline: UInt64) {
    let gig = self.getGig(gigId: gigId)
    if (gig.status != "completed") {
      panic("Gig is not completed")
    }

    gig.status = "WIP"

    gig.deadline = gig.deadline + newDeadline

    gig.warningCount = gig.warningCount + 1

  }

  
  pub fun ReportGig(gigId: UInt64, ) {
    let gig = self.getGig(gigId: gigId)
    if (gig.status == "WIP" && gig.warningCount == 3) {
      // Transfer funds from escrow to gigowner account
      // Add your custom funds transfer logic here
    }
    if (gig.status == "completed" && gig.warningCount == 3) {
      // Transfer funds from escrow to freelancer account
      // Add your custom funds transfer logic here
      // getFreelacers struct and increment his no of completed gig
    }

    gig.status = "reported"


  }

  // Verify Freelancer
  pub fun verifyFreelancer(freelancerAddress: Address, stars: UInt32) {
    if let freelancer = self.freelancers[freelancerAddress] {
      if !freelancer.verified {
        freelancer.verified = true
        freelancer.stars = stars
      }
    }

  }

  // Update Freelancer
  pub fun updateFreelancer(freelancerAddress: Address) {
    if let freelancer = self.freelancers[freelancerAddress] {
      // update freelancers parameter
    }

  }


  // Internal helper function to get gig 
  access(contract) fun getGig(gigId: UInt64): Gig {
    let gig = self.gigs[gigId] ?? panic("Gig not found")
    return gig
  }

  // Internal helper function to generate a unique gig ID
  access(contract) fun getCurrentGigId(): UInt64 {
  
    // Generate and return a unique gig ID based on the current state
      return self.noOfCreatedGigs

  }

 
}