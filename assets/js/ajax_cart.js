

function ajaxHandler(e) {

    e.preventDefault();
    var post_url = jQuery(this).attr("action");//get form action url
    var form_data = jQuery(this).serialize(); //Encode form elements for submission

    jQuery.post(post_url, form_data, function (response) {
        jQuery.bootstrapGrowl(response.message, {
            offset: {from: 'top', amount: 60},
            type: 'success'
        });
        jQuery(".cart-count").text(response.cart_count)
    });
}

var ajaxCart = {
    init: function () {
        jQuery(function () {
            jQuery(".cart-form").on('submit', ajaxHandler)
        })
    }

}
export default ajaxCart