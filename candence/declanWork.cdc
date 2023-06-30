pub contract DeclanWork {
  
  //
  // state
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

    init(_name: String, _address: Address, _portfolioURL: String,) {
      self.name = _name
      self.address = _address
      self.portfolioURL = _portfolioURL
      self.skills = []
    }
  } 


  pub struct GigOwner {

  }


  pub var freelancers: {String: Freelancer}


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