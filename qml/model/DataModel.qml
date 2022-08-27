import QtQuick 2.0
import Felgo 3.0

Item {
    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy

    // model data properties
    readonly property alias launches: _.launches
    readonly property alias finalResults: _.finalResults
    readonly property alias launchDetails: _.launchDetails

    // action error signals
    signal fetchLaunchesFailed(var error)
    signal fetchLaunchDetailsFailed(int id, var error)

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        // action 1 - fetchLaunches
        onFetchLaunches: {
            // check cached value first
            var cached = cache.getValue("Launches")
            if(cached)
                _.launches = cached

                // load from api
                api.getLaunches(filter, 
                function(data, finalResults) {
                // cache data before updating model property
                cache.setValue("launches", data)
                _.launches = data
                _.finalResults = finalResults
            },
            function(error) {
            // action failed if no cached data
            if(!cached)
            fetchLaunchesFailed(error)
        })
    }

    // action 2 - fetchTodoDetails
    onFetchLaunchDetails: {
        // check cached todo details first
        var cached = cache.getValue("launch_"+id)
        if(cached)
        {
            _.launchDetails[id] = cached
            launchDetailsChanged() // signal change within model to update UI
        }

        api.getLaunchById(id,
        function(data) {
        
        // cache data first
        cache.setValue("launch_"+id, data[0])
        _.launchDetails[id] = data[0]
        launchDetailsChanged()
    },
    function(error) {
    // action failed if no cached data
    if(!cached) {
    fetchLaunchDetailsFailed(id, error)
}
})
}

// action 4 - clearCache
onClearCache: {
    cache.clearAll()
}
}
// you can place getter functions here that do not modify the data
// pages trigger write operations through logic signals only

// rest api for data access
RestAPI {
    id: api
    maxRequestTimeout: 3000 // use max request timeout of 3 sec
}

// storage for caching
Storage {
    id: cache
}

// private
Item {
    id: _

    // data properties
    property var launches: []  // Array
    property var finalResults: false  // Bool
    property var launchDetails: ({}) // Map
}
}
