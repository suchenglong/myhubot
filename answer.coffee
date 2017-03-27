fs=require('fs')
DomJS = require("dom-js").DomJS;
class Answer
	parseDom:(file,cb) ->
		fs.readFile file, 'utf-8', (err,data) =>
			#
			xml='<aiml>\n'+data+'</aiml>'
			if err 
				console.log 'read file faild'
			if not err
				document=""
				new DomJS().parse xml, (err, dom) =>
					if err
						console.log 'parse document faild'
					if not err
						document=dom.children
				cb document

	getAnswer:(file,question,cb) ->
		new Answer().parseDom file,(dom)->
			new Answer().cleanDom dom
			answer=new Answer().travereseThroughDomToFindMatchingPattern dom,question
			cb answer
		#new aiml.parseFiles path,(err,topics) =>
		#	engine=new aiml.AiEngine 'categories',topics,{name:'say'}
		#	answer=""
		#	engine.reply {name:'say'},question,(err,responce) =>
		#		answer=responce
	
	setAnswer:(file,question,answer) ->
		#category = builder.create 'category'
		#category.ele('pattern',question).end { pretty: true}
		#category.ele('template',answer).end { pretty: true}
		category='<category>\n  <pattern>'+question+'</pattern>\n  <template>'+answer+'</template>\n</category>\n'
		fs.appendFile file,category
		#this.parseDom file,(dom) =>
		#	categorys=dom.children
		#	categorys.push category
		#	length=categorys.length
		#	console.log length
		#	categorys[length]=category
		#	fs.open file, 'wx', (err, fd) => 
		#	  	if err 
		#	    	if err.code is "EEXIST"
		#	      		console.error('myfile already exists');
		#	      		return;
		#	    	else 
		#	      		throw err;
		#	    console.log fd
		#	 	fs.writeMyData(fd);
		#	
		#	#console.log categorys
		#	for categoryD,i in categorys
		#		if categoryD.name is 'category'
		#			console.log 'sss'

	travereseThroughDomToFindMatchingPattern:(categories,question) ->
		for categorie,i in categories
        	if categorie.name is 'category'
            	text = new Answer().travereseThroughDomToFindMatchingPattern categorie.children
            	matches = new Answer().checkIfMessageMatchesPattern question, text
            	if matches
	            	answer=new Answer().findFinalTextInTemplateNode categorie.children
	            	if answer
	                	return answer;
        	else if categorie.name is 'pattern'
            	text = categorie.children[0].text
            	return text;

	cleanDom:(childNodes) ->
		for childNode,i in childNodes
			if (childNode is not undefined) and (childNode.hasOwnProperty 'text')  and (typeof childNode.text is 'string')
		            # remove all nodes of type 'text' when they just contain '\r\n'. This indicates line break in the AIML file
		        	childNodes.splice i, 1
		       		if i is childNodes.length-1
		           		break
	findCorrectCategory:(clientInput, domCategories) ->
    	this.travereseThroughDomToFindMatchingPattern
	findFinalTextInTemplateNode:(childNodesOfTemplate) ->
    	text = ''
        #traverse through template nodes until final text is found
        #return it then to very beginning x for x in [1..10]
    	for i in [0..childNodesOfTemplate.length] by 1
        	if childNodesOfTemplate[i].name is 'template'
                #traverse as long through the dom until final text was found
                #final text -> text after special nodes (bot, get, set,...) were resolved
            	return new Answer().findFinalTextInTemplateNode childNodesOfTemplate[i].children           
            #else if childNodesOfTemplate[i].name is 'condition'
            #    return new Answer().resolveSpecialNodes childNodesOfTemplate            
        	else if childNodesOfTemplate[i].name is 'random'
                #if random node was found, it's children are 'li' nodes.
                #pick one li node by random and continue dom traversion until final text is found
            	randomNumber = Math.floor(Math.random() * (childNodesOfTemplate[i].children.length))
            	return new Answer().findFinalTextInTemplateNode [childNodesOfTemplate[i].children[randomNumber]]        
            #else if childNodesOfTemplate[i].name is 'srai'
            #    #take pattern text of srai node to get answer of another category
            #    sraiText = '' + new Answer().findFinalTextInTemplateNode childNodesOfTemplate[i].children
            #    sraiText = sraiText.toUpperCase();
            #    referredPatternText = sraiText;
            #    #call findCorrectCategory again to find the category that belongs to the srai node
            #    text = new Answer().findCorrectCategory referredPatternText, domCategories
            #    return text;
        	else if childNodesOfTemplate[i].name is 'li'
            	return new Answer().findFinalTextInTemplateNode(childNodesOfTemplate[i].children);           
        	else if childNodesOfTemplate[i].name is 'pattern'
                #(here it is already checked that this is the right pattern that matches the user input)
                #make use of the functions of the special nodes - bot, set, get...
            	new Answer().resolveSpecialNodes(childNodesOfTemplate[i].children);
            	continue;            
            #else if childNodesOfTemplate[i].name is 'bot'
            #    text = new Answer().resolveSpecialNodes(childNodesOfTemplate);
            #    return text;            
            #else if childNodesOfTemplate[i].name is 'set'
            #    text = new Answer().resolveSpecialNodes(childNodesOfTemplate);
            #    return text;            
            #else if childNodesOfTemplate[i].name is 'get'
            #    text = new Answer().resolveSpecialNodes(childNodesOfTemplate);
            #    return text;           
            #else if childNodesOfTemplate[i].name is 'sr'
            #    text = new Answer().resolveSpecialNodes(childNodesOfTemplate);
            #    return text;            
            #else if childNodesOfTemplate[i].name is 'star'
            #    text = new Answer().resolveSpecialNodes(childNodesOfTemplate);
            #    return text;           
            #else if childNodesOfTemplate[i].name is 'that'
        	else
                #this is the text of template node
                #after all special functions (bot, get, set,...) were resolved
                #return that text
            	text = new Answer().resolveSpecialNodes(childNodesOfTemplate);
            	if  ((text.match '[\\n|\\t]*[^A-Z|^a-z|^\u4e00-\u9fa5|^!|^?]*')[0] is '') and ((text.indexOf 'function ()')is -1)
                    return (text);
                
            
	resolveSpecialNodes:(innerNodes) ->
    	text=''
    	for innerNode,i in innerNodes
    		text = text + innerNode.text;
    	text=new Answer().cleanStringFormatCharacters text
    	return text
    # remove string control characters (like line-breaks '\r\n', leading / trailing spaces etc.)
	cleanStringFormatCharacters: (str) ->
    	cleanedStr = str.replace /\r\n/gi, ''
    	cleanedStr = cleanedStr.replace /^\s*/, ''
    	cleanedStr = cleanedStr.replace /\s*$/,''
    	return cleanedStr;

    checkIfMessageMatchesPattern:(userInput,regexPattern) ->
    	if userInput.charAt(0) is not " "
        	userInput = " " + userInput
	    lastCharacterPosition  = userInput.length - 1;
	    lastCharacter = userInput.charAt lastCharacterPosition
	    if lastCharacter is not " "
	        userInput = userInput + " "
    	matchedString = userInput.match regexPattern
    	if matchedString
    		return true

module.exports = Answer
				
