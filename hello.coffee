Answer = require('./answer.coffee')
answer=new Answer()
file =process.env.ANSWER_FILE_PATH
#builder = require('xmlbuilder');
#fs = require('fs');
module.exports = (robot) ->

    #fs.readdir '/home/clsu/aimlDir/',(err,files) -> 
    #	files.forEach (file,index) =>
    #		files[index] = '/home/clsu/aimlDir/' +file
	#    aimlInterpreter=new AIMLInterpreter {name:'WireInterpreter', age:'42'}
	#    aimlInterpreter.loadAIMLFilesIntoArray files
	#    robot.respond /question (.*)/i, (res) ->
	#          	@question=res.match[1]
	#          	callback = (answer, wildCardArray, input) =>
	#               res.send "#{answer}" if answer
	#               res.send "@renhuan i don't hnow the question #{@question}" unless answer
	#          	aimlInterpreter.findAnswerInLoadedAIMLFiles @question,callback


    #xml = builder.create('root').ele('xmlbuilder').ele('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git').end({ pretty: true});
    #console.log(xml);
    #fs.appendFile '/home/clsu/aimlDir/update.aiml', '<category><pattern>hello</pattern><template>I start testing that.</template></category>', () =>
	#  	console.log('追加内容完成');
	
    #fs.readFile '/home/clsu/aimlDir/update.aiml','utf-8',(err,data) =>
    #	console.log data
    
    #console.log(fso)
    #test=builder.begin '/home/clsu/test.aiml.xml'
    #console.log test
    #aimlInterpreter=new AIMLInterpreter {name:'WireInterpreter', age:'20'}
    #aimlInterpreter.loadAIMLFilesIntoArray ["/home/clsu/aimlDir/test.aiml.xml"]

    robot.respond /setAnswer (.*)/i,(res) ->
    	command=res.match[1]
    	answerAraay=command.split('|')
    	if answerAraay.length is 2
    		answer.setAnswer file,answerAraay[0],answerAraay[1]
    		answer=new Answer()
    		res.reply '设置答案成功!'
    	else
    		res.reply '你输入的格式不满足要求,请按这种格式输入 问题|答案'

    robot.respond /question (.*)/i,(res) ->
    	command=res.match[1]
    	answerCommand = answer.getAnswer file,command,(response) =>
    		if response
    			res.reply response
    		else
    			res.reply '您的问题太深奥了,麻烦教教我呢.' 

    #robot.hear /^hubot:? (.+)/i, (res) ->
	#    response = "Sorry, I'm a diva and only respond to #{robot.name}"
	#    response += " or #{robot.alias}" if robot.alias
	#    res.reply response
	#
    #robot.hear /^hubot11:? (.+)/i, (res) ->
	#    response = "Sorry, I'm a diva and only respond to #{robot.name}"
	#    response += " or #{robot.alias}" if robot.alias
	#    res.reply response
  