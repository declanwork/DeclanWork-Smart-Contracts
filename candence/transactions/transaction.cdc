import DeclanWork from "../contract/declanWork.cdc"

transaction(txName: String) {
  prepare(signer: AuthAccount ) {
    log(signer.address)
  }

  execute {
    DeclanWork.changeNameOfFreelancer(newnameOfFreelancer: txName)
  }
}