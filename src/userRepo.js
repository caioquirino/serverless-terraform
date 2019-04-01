class UserRepo {
  constructor(log, documentClient, tableName) {
    this.log = log
    this.tableName = tableName
    this.documentClient = documentClient
  }

  async listAllUsers () {
    this.log.info("Listing all users")
    const params = {
      TableName : this.tableName,
      ProjectionExpression: "user_id, email"
    };
    return (await this.documentClient.scan(params).promise()).Items
  }

}
module.exports = UserRepo
