// $(document).ready(function(){

//     var activeElement = $('.summary-container:visible');
    
//     if (activeElement.length > 0) {
//         var top = activeElement.offset().top - parseFloat(activeElement.css('marginTop').replace(/auto/, 0));
//         var summaryHeight = activeElement.outerHeight();
//         var footTop = $('footer.footer').offset().top - parseFloat($('footer.footer').css('marginTop').replace(/auto/, 0));
//         var windowHeight = $(window).height();
//         var maxY = footTop - summaryHeight - 40;
//     }
    

//     // order item

//     $('.hideshow_topping').on('click', function(){
//     	footTop = $('footer.footer').offset().top - parseFloat($('footer.footer').css('marginTop').replace(/auto/, 0));
//     	summaryHeight = activeElement.outerHeight();
//     	maxY = footTop - summaryHeight - 40;
//     });


//     // order additional

//     $('.right-cell input').on('change', function(){
//     	footTop = $('footer.footer').offset().top - parseFloat($('footer.footer').css('marginTop').replace(/auto/, 0));
//     	summaryHeight = activeElement.outerHeight();
//     	maxY = footTop - summaryHeight - 80;
//     });


//     $('.right-cell img').on('click', function(){
//     	footTop = $('footer.footer').offset().top - parseFloat($('footer.footer').css('marginTop').replace(/auto/, 0));
//     	summaryHeight = activeElement.outerHeight();
//     	maxY = footTop - summaryHeight - 80;
//     });

//     $('.catering_order_boolean').on('click', function(){
//     	footTop = $('footer.footer').offset().top - parseFloat($('footer.footer').css('marginTop').replace(/auto/, 0));
//     	maxY = footTop - summaryHeight - 80;
//     });


//     $(window).scroll(function(evt) {
//         var y = $(this).scrollTop();

//         if (y > top && summaryHeight < windowHeight) {
//             if (y < maxY) {
//                activeElement.addClass('fixed').removeAttr('style');
//             } else {
//                 activeElement.removeClass('fixed').css({
//                     position: 'absolute',
//                     top: (maxY - top) + 'px'
//                 });
//             }
//         } else {
//             activeElement.removeClass('fixed');
//         }
//     });
// });