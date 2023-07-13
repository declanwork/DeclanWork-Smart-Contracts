// import DeclanWork from "./cadence/DeclanWork.cdc"

// pub fun main(): {String} {

//     // Instantiate the Declanwork contract
//     let declanwork = DeclanWork(address: 0xf88f3b6f4c595384)

//     // Read the number of freelancers
//     let noOfFreelancers = declanwork.noOfFreelancers

//     // Read the number of gig owners
//     let noOfGigOwners = declanwork.noOfGigOwners

//     // Read the number of created gigs
//     let noOfCreatedGigs = marketplace.noOfCreatedGigs

//     // Read the freelancer details
//     let freelancerAddress = 0x<freelancer-address>
//     let freelancer = declanwork.freelancers[freelancerAddress]

//     // Read the gig owner details
//     let gigOwnerAddress = 0x<gig-owner-address>
//     let gigOwner = declanwork.gigOwners[gigOwnerAddress]

//     // Read the gig details
//     let gigId = 1
//     let gig = declanwork.gigs[gigId]

//     // Prepare the result to be returned
//     let result: {String} = {
//         "Number of Freelancers: \(noOfFreelancers)",
//         "Number of Gig Owners: \(noOfGigOwners)",
//         "Number of Created Gigs: \(noOfCreatedGigs)",
//         "Freelancer Details: \(freelancer)",
//         "Gig Owner Details: \(gigOwner)",
//         "Gig Details: \(gig)"
//     }

//     return result
// }