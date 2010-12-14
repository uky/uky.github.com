function parseXml(xml) {
    var working = false;
    var working_table = '';
    var table_empty = true;
    $(xml).find('Row').each(function(){
        var cells = $(this).children();
        if(cells.length == 1){
            if(working && !table_empty) { // close previous table
                working_table += '</table>';
                $('#retainer').append(working_table);
            }

            var category = cells.first().text();
            table_empty = true;
            working_table = '<table class="stuffs"><tr><th>' + category + '</th></tr>';
        }
        else if(cells.length == 2){
            var item_name = cells.first().text();
            var item_url = cells.first().attr('ss:HRef');
            var quantity = cells.last().text();

            if (quantity != 0 && item_name) {
                working_table += '<tr><td>';
                if(item_url)
                    working_table += '<a href="' + item_url + '">';
                working_table += item_name;
                if(item_url)
                    working_table += '</a></td>';
                working_table += '<td class="numeric">' + quantity + '</td>';
                working_table += '</tr>';
                table_empty = false;
            }
        }

        working = true;
    });
    working_table += '</table>';
    if (!table_empty)
        $('retainer').append(working_table);
    working = false;

    YG.Syndication.Regen();

    $('#retainer').masonry({
        //columnWidth: 200,
        itemSelector: '.stuffs'
    });
}
