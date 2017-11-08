function postNote() {
    console.log('Posting note');
    $.ajax({
	method: "POST",
	url: "/overview/note",
	data: {
	    note: $("#note_message").val(),
	    candidate_id: window.location.href.substr(window.location.href.lastIndexOf('/') + 1)
	}
    }).done(function( msg ) {
	console.log(msg);
	var divBody = document.createElement('div');
	divBody.setAttribute('class', 'email-content-body');
	
	var divItem = document.createElement('div');
	divItem.setAttribute('class', 'email-item pure-g');
	divBody.appendChild(divItem);
	
	var divName = document.createElement('div');
	divName.setAttribute('class', 'pure-u');
	var h5 = document.createElement('h5');
	h5.setAttribute('class', 'email-name');
	h5.appendChild(document.createTextNode(msg['user_id']));
	divName.appendChild(h5);
	divName.appendChild(document.createTextNode(msg['updated_at']));
	divItem.appendChild(divName);
	
	var divNote = document.createElement('div');
	divNote.setAttribute('class', 'pure-u-3-4');
	var p = document.createElement('p');
	p.appendChild(document.createTextNode(msg['message']));
	divNote.appendChild(p);
	divItem.appendChild(divNote);

	$('#notes').append(divBody);
	$("#note_message").val('');
    }).fail(function( jqXHR, textStatus ) {
	console.log("Request failed: " + textStatus);
    });
}
