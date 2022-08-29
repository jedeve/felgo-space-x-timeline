import QtQuick 2.0
import Felgo 3.0

Item {

    // loading state
    readonly property bool busy: HttpNetworkActivityIndicator.enabled

    property int limit: 10

    property string filterValue: ""

    // configure request timeout
    property int maxRequestTimeout: 5000

    // initialization
    Component.onCompleted: {
        // immediately activate loading indicator when a request is started
        HttpNetworkActivityIndicator.setActivationDelay(0)
    }

    // private
    QtObject {
        id: _
        property string launchUrl: "https://api.spacexdata.com/v3/launches"

        function fetch(url, success, error)
        {
            HttpRequest.get(url)
            .timeout(maxRequestTimeout)
            .then(function(res) { 
                let results = res.body
                if (results.length === 0) {
                    results = [""]
                }
                success(results, limit !== res.body.length) 
                limit += 10
                })
            .catch(function(err) { error(err) });
        }

    }

    // public rest api functions

    function getLaunches(filter, success, error)
    {
        if (filter) {
            filterValue = filter.split(" ").join("")
            filterValue = filterValue.toLowerCase()
            limit = 10
        }

        const filterSplit = filterValue.split(',')
        console.log(`${_.launchUrl}?order=desc&limit=${limit}&${filterSplit[0]}=${filterSplit[1]}`)
        _.fetch(`${_.launchUrl}?order=desc&limit=${limit}&${filterSplit[0]}=${filterSplit[1]}`, success, error)
    }

    function getLaunchById(id, success, error)
    {
        _.fetch(_.launchUrl+"?flight_number="+id, success, error)
    }
}
