# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$(document).ready ->
		
		$('a.menu-toggle').click (e) ->
			e.preventDefault();
			
			if $(this).hasClass('open')
			  	$(this).removeClass('open');
			  	$('div.dropdown-menu').removeClass('open');
			else 
			  $(this).addClass('open');
			  $('div.dropdown-menu').addClass('open');

		$('a.close-menu').click (e) ->
			e.preventDefault();
			$('div.dropdown-menu').removeClass('open');
			$('a.menu-toggle').removeClass('open');

		$('.pizza-carousel').carousel();

		$('.pizza-carousel-control.right').click ->
			$('.pizza-carousel').carousel('next')

		$('.pizza-carousel-control.left').click ->
			$('.pizza-carousel').carousel('prev')

