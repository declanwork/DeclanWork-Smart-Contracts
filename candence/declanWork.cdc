pub contract DeclanWork {
  
  //
  // state
  // 
  pub var noOfFreelancers: UInt256
  pub var noOfGigOwners: UInt256
  pub var noOfCreatedGigs: UInt256

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
      pre {
          _name.length > 0: "Freelancer name cannot be empty"
      }
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

    init(_gigOwner: String, _address: Address) {
      pre {
          _address.length > 0: "Freelancer address cannot be empty"
      }
      self.gigOwner = _gigOwner
      self.gigOwnerAddress = _address
      self.isVerified = false
      self.stars = []
    }

  }

  pub struct Gig {
    pub var id: UInt64
    pub var owner: Address
    pub var gigTitle: String
    pub var gigDescription: String
    pub var gigTimeline: String
    pub var budget: UFix64
    pub var featureGig: Bool
    pub var freelancer: Freelancer?
    pub var completed: Bool

    init() {
      pre {
          _name.length > 0: "Freelancer name cannot be empty"
      }
      self.id = 0
      self.owner = Address(0x0)
      self.gigTitle = ""
      self.gigDescription = ""
      self.gigTimeline = ""
      self.budget = 0.0
      self.featureGig = false
      self.freelancer = nil
      self.completed = false
    }

  }


// Store the freelancers and gigs
  pub var freelancers: {Address: Freelancer}
  pub var gigs: {UInt64: Gig}


  init() {
    self.freelancers = {}
  }


  pub fun createFreelancerAccount() {
    pre{
      self.freelancers.contain(name)
    }
  }


  pub fun verifyFreelancer


  pub fun createGig


  pub fun bidForGig


  pub fun lockGigPayment



  //
  // logic
  // 
  pub fun changeNameOfFreelancer(newnameOfFreelancer: String) {
    self.nameOfFreelancer = newnameOfFreelancer
  }
  init() {
    self.nameOfFreelancer = "John Doe"
  }
}