const BREWERIES = {}

BREWERIES.show = () => {
    $("#brewerytable tr:gt(0)").remove()
    const table = $("#brewerytable")

    BREWERIES.list.forEach((brewery) => {
        let active = (brewery['active'] == true) ? true : false
        table.append('<tr>'
        + '<td>' + brewery['name'] + '</td>'
        + '<td>' + brewery['year'] + '</td>'
        + '<td>' + brewery['beers']['count'] + '</td>'
        + '<td>' + active + '</td>'
        + '</tr>')
    })
}

document.addEventListener("turbolinks:load", () => {
    if ($("#brewerytable").length == 0){
        return
    }

    $.getJSON('breweries.json', (breweries) => {
        BREWERIES.list = breweries
        BREWERIES.show()
    });
})