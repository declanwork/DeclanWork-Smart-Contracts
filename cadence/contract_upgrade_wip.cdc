// pub contract DeclanWork {

//     // Escrow contract

//     pub struct Escrow {
//         // Declaring the state variables
//         pub var buyer: Address
//         pub var seller: Address
//         pub var arbiter: Address
        
//         // Defining an enum 'State'
//         pub enum State {
//             case await_payment
//             case await_delivery
//             case complete
//         }
    
//         // Declaring the state variable
//         pub var state: State
    
//         // Defining a function modifier 'inState'
//         modifier (expectedState: State) {
//             pre {
//                 state == expectedState
//             }
//         }
    
//         // Defining a function modifier 'onlyBuyer'
//         modifier onlyBuyer() {
//             pre {
//                 let sender = getAccountAddress()
//                 sender == buyer || sender == arbiter
//             }
//         }
    
//         // Defining a function modifier 'onlySeller'
//         modifier onlySeller() {
//             pre {
//                 getAccountAddress() == seller
//             }
//         }
    
//         // Defining the constructor
//         init(buyer: Address, seller: Address) {
//             self.arbiter = signer
//             self.buyer = buyer
//             self.seller = seller
//             self.state = State.await_payment
//         }
    
//         // Defining a function to confirm payment
//         pub fun confirmPayment() {
//             execute {
//                 state = State.await_delivery
//             }
//         }
//         pre {
//             onlyBuyer()
//             inState(State.await_payment)
//         }
    
//         // Defining a function to confirm delivery
//         pub fun confirmDelivery() {
//             execute {
//                 seller.transfer(Ether(balance: self.account.balance))
//                 state = State.complete
//             }
//         }
//         pre {
//             onlyBuyer()
//             inState(State.await_delivery)
//         }
    
//         // Defining a function to return payment
//         pub fun returnPayment() {
//             execute {
//                 buyer.transfer(Ether(balance: self.account.balance))
//             }
//         }
//         pre {
//             onlySeller()
//             inState(State.await_delivery)
//         }
//     }

//     // Defining an enum 'State'
//     pub enum State {
//         case await_payment
//         case await_delivery
//         case complete
//     }

//     // Declaring the state variable
//     pub var state: State

//     // GigOwner struct
//     pub struct GigOwner {
//         pub(set) var gigOwner: String
//         pub(set) var gigOwnerAddress: Address
//         pub(set) var isVerified: Bool
//         pub(set) var stars: [String]

//         init(gigOwner: String, gigOwnerAddress: Address, isVerified: Bool, stars: [String]) {
//             self.gigOwner = gigOwner
//             self.gigOwnerAddress = gigOwnerAddress
//             self.isVerified = isVerified
//             self.stars = stars
//         }
//     }

//     // Gig struct
//     pub struct Gig {
//     pub(set) var id: UInt64
//     pub(set) var buyer: Address
//     pub(set) var seller: Address
//     pub(set) var title: String
//     pub(set) var description: String
//     pub(set) var gigTimeline: String
//     pub(set) var deadline: Int16
//     pub(set) var budget: UFix64
//     pub(set) var featureGig: Bool
//     pub(set) var freelancer: Freelancer?
//     pub(set) var bidders: {Address: Bidder?}
//     pub(set) var status: String?
//     pub(set) var completed: Bool
//     pub(set) var escrow: UFix64

//     init(id: UInt64, buyer: Address, seller: Address, title: String, description: String, gigTimeline: String, deadline: Int16, budget: UFix64, featureGig: Bool, freelancer: Freelancer?, status: String?, completed: Bool, escrow: UFix64) {
//         self.id = id
//         self.buyer = buyer
//         self.seller = seller
//         self.title = title
//         self.description = description
//         self.gigTimeline = gigTimeline
//         self.deadline = deadline
//         self.budget = budget
//         self.featureGig = featureGig
//         self.freelancer = freelancer
//         self.bidders = {}
//         self.status = status
//         self.completed = completed
//         self.escrow = escrow
//     }
// }


//     // Bidder struct
//     pub struct Bidder {
//         pub var freelancerName: String
//         pub var freelancerSkills: [String]
//         pub var freelancerPortfolioURL: String
//         pub var bidAmount: UFix64

//         init(freelancerName: String, freelancerSkills: [String], freelancerPortfolioURL: String, bidAmount: UFix64) {
//             self.freelancerName = freelancerName
//             self.freelancerSkills = freelancerSkills
//             self.freelancerPortfolioURL = freelancerPortfolioURL
//             self.bidAmount = bidAmount
//         }
//     }

//     // Freelancer struct
//     pub struct Freelancer {
//         pub(set) var name: String
//         pub(set) var address: Address
//         pub(set) var portfolioURL: String
//         pub(set) var skills: [String]
//         pub(set) var categories: [String]
//         pub(set) var verified: Bool
//         pub(set) var stars: [String]

//         init(name: String, address: Address, portfolioURL: String, skills: [String], categories: [String], verified: Bool, stars: [String]) {
//             self.name = name
//             self.address = address
//             self.portfolioURL = portfolioURL
//             self.skills = skills
//             self.categories = categories
//             self.verified = verified
//             self.stars = stars
//         }
//     }

//     // Store the freelancers, gig owners, and gigs
//     pub var freelancers: {Address: Freelancer}
//     pub var gigOwners: {Address: GigOwner}
//     pub var gigs: {UInt64: Gig}

//     pub var noOfFreelancers: UInt64
//     pub var noOfGigOwners: UInt64
//     pub var noOfCreatedGigs: UInt64

//     // Declaring the escrow variables
//     pub var buyer: Address
//     pub var seller: Address
//     pub var arbiter: Address

//     init() {
//         self.freelancers = {}
//         self.gigOwners = {}
//         self.gigs = {}
//         self.noOfFreelancers = 0
//         self.noOfGigOwners = 0
//         self.noOfCreatedGigs = 0

//         self.arbiter = contract.Address
//         self.buyer = Address(0)
//         self.seller = Address(0)
//         self.state = State.await_payment

//     }

//     // Function to create a freelancer account
//     pub fun createFreelancerAccount(
//         name: String,
//         portfolioURL: String,
//         skills: [String],
//         categories: [String],
//         verified: Bool,
//         stars: [String]
//     ) {
//         self.freelancers[self.account.address] = Freelancer(
//             name: name,
//             address: self.account.address,
//             portfolioURL: portfolioURL,
//             skills: skills,
//             categories: categories,
//             verified: false,
//             stars: stars,
//         )
//     }

//     // Function to create a gig owner account
//     pub fun createGigOwnerAccount(
//         gigOwner: String,
//         gigOwnerAddress: Address,
//         isVerified: Bool,
//         stars: [String]
//     ) {
//         // Perform necessary setup for gig owner account
//         let newGigOwner = GigOwner(
//             gigOwner: gigOwner,
//             gigOwnerAddress: self.account.address,
//             isVerified: isVerified,
//             stars: stars,
//         )
//         self.gigOwners[self.account.address] = newGigOwner
//     }

//     // Function to create a new gig
//     pub fun createGig(
//         buyer: Address,
//         seller: Address,
//         title: String,
//         description: String,
//         budget: UFix64,
//         deadline: Int16,
//         gigTimeline: String,
//         featureGig: Bool,
//         freelancer: Freelancer?,
//         status: String?,
//         completed: Bool,
//         escrow: UFix64
// ): UInt64 {
//     let newGigId = self.getCurrentGigId()
//     let gig = Gig(
//         id: newGigId,
//         buyer: buyer,
//         seller: seller,
//         title: title,
//         description: description,
//         gigTimeline: gigTimeline,
//         deadline: deadline,
//         budget: budget,
//         featureGig: featureGig,
//         freelancer: freelancer,
//         bidders: {},
//         status: status,
//         completed: completed,
//         escrow: escrow
//     )
//     self.gigs[newGigId] = gig

//     emit GigCreated(gigId: newGigId)

//     self.noOfCreatedGigs = self.noOfCreatedGigs + 1

//     return newGigId
// }


//     // Function to place a bid on a gig
//     pub fun placeBid(gigId: UInt64, bidAmount: UFix64) {
//         let gig = self.getGig(gigId: gigId)

//         // Perform validation checks
//         if gig.status != nil && gig.status != "open" {
//             panic("Gig is not open")
//         }
//         if bidAmount > gig.budget {
//             panic("Bid amount must be less than or equal to gig budget")
//         }

//         // Retrieve the bidder's information from the freelancers dictionary
//         let bidderAddress = self.account.address
//         let freelancer = self.freelancers[bidderAddress]
//         if freelancer == nil {
//             panic("Freelancer not found")
//         }

//         // Store the bid information
//         let bidder = Bidder(
//             freelancerName: freelancer!.name,
//             freelancerSkills: freelancer!.skills,
//             freelancerPortfolioURL: freelancer!.portfolioURL,
//             bidAmount: bidAmount
//         )
//         gig.bidders[bidderAddress] = bidder
//         gig.status = "bid_placed"

//         emit BidPlaced(gigId: gigId, bidder: bidderAddress)
//     }

//     // Function to confirm gig completion
//     pub fun completeGig(gigId: UInt64) {
//         let gig = self.getGig(gigId: gigId)

//         // Perform validation checks and confirm completion
//         if gig.status != "open" {
//             panic("Gig is not open")
//         }

//         // Transfer funds from escrow to freelancer account
//         // Add your custom funds transfer logic here

//         // Mark gig as completed
//         gig.status = "completed"
//         gig.completed = true
//     }

//     pub fun confirmGig(gigId: UInt64) {
//         let gig = self.getGig(gigId: gigId)
//         if gig.status != "completed" {
//             panic("Gig is not completed")
//         }
//         gig.escrow = 0.0
//     }

//     // Verify Freelancer
//     pub fun verifyFreelancer(freelancerAddress: Address) {
//         if let freelancer = self.freelancers[freelancerAddress] {
//             if !freelancer.verified {
//                 freelancer.verified = true
//             }
//         }
//     }

//     // Internal helper function to get gig
//     access(contract) fun getGig(gigId: UInt64): Gig {
//         let gig = self.gigs[gigId] ?? panic("Gig not found")
//         return gig
//     }

//     // Internal helper function to generate a unique gig ID
//     access(contract) fun getCurrentGigId(): UInt64 {

//         // Generate and return a unique gig ID based on the current state
//         return self.noOfCreatedGigs
//     }

//     // Internal helper function to lock Gig payment
//     access(contract) fun lockGigPayment(gigId: UInt64) {
//         let gig = self.getGig(gigId: gigId)
//         if gig.status != "completed" {
//             panic("Gig is not completed")
//         }

//         // gig.escrow = UFix64(0)
//     }
// }

