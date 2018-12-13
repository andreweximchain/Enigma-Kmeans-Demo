const http = require("http")
const kmeansmodelfactory = artifacts.require('KMeansFactory.sol')

module.exports = function(deployer) {
  return (
    deployer.then(() => {
      return new Promise((resolve, reject) => {
        const request = http.get('http://localhost:8081', response => {
          if (response.statusCode < 200 || response.statusCode > 299) {
            reject(
              new Error("failed to load page, status" + response.statusCode)
            )
          }
          const body = [];
          response.on('data', chunk => body.push(chunk))
          response.on('end', () => resolve(body.join('')))
        })
        request.on('error', err => reject(err))
      })
    }).then(enigmaAddress => {
      console.log('Got Enigma Contract address: ' + enigmaAddress)
      return deployer.deploy(
        kmeansmodelfactory,
        enigmaAddress
      )
    }).catch(err => console.error(err))
  )
}
