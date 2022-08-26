import QtQuick 2.0
import Felgo 3.0

Item {

    // loading state
    readonly property bool busy: HttpNetworkActivityIndicator.enabled

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
        property string todoUrl: "https://api.spacexdata.com/v3/launches?limit=10"

        function fetch(url, success, error)
        {
            HttpRequest.get(url)
            .timeout(maxRequestTimeout)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }

        function post(url, data, success, error)
        {
            HttpRequest.post(url)
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .send(data)
            .then(function(res) { success(res.body) })
            .catch(function(err) { error(err) });
        }
    }

    // public rest api functions

    function getLaunches(success, error)
    {
        _.fetch(_.todoUrl, success, error)
    }

    function getLaunchById(id, success, error)
    {
        _.fetch(_.launchUrl+"/"+id, success, error)
    }
}
