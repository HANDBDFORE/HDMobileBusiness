
var target = UIATarget.localTarget();
//login
function login(){
	target.frontMostApp().mainWindow().textFields()[0].tap();
	target.frontMostApp().keyboard().typeString("162");
	
	target.frontMostApp().mainWindow().secureTextFields()[0].tap();
	target.frontMostApp().keyboard().typeString("handhand");
	
	target.frontMostApp().mainWindow().buttons()["登录"].tap();
}

function batch(i){
	target.frontMostApp().toolbar().buttons()[i%2].tap();
	target.frontMostApp().mainWindow().elements()[3].rightButton().tap();
	target.delay(2);
}

function single(i){
	
	//employee
	target.frontMostApp().navigationBar().rightButton().tap();
	target.tap({x:126.00, y:287.00});
	//refresh
	target.frontMostApp().navigationBar().buttons()[2].tap();
	//forward &backward
	target.frontMostApp().navigationBar().buttons()[4].tap();
	target.frontMostApp().navigationBar().buttons()[3].tap();
	//
	target.frontMostApp().toolbar().buttons()[i%3].tap();
	if(i%3 == 2)
	{
		target.delay(1);
		target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0]		
		target.frontMostApp().keyboard().typeString("ma");
		target.frontMostApp().keyboard().scrollViews()[0].buttons()["马，马克思主义的马"].tap();		
		target.frontMostApp().mainWindow().scrollViews()[0].tableViews()[0].cells()[0].tap();
		
	}	
	target.frontMostApp().navigationBar().rightButton().tap();		
	target.delay(1);	
}

function search(){
	target.frontMostApp().mainWindow().tableViews()[0].searchBars()[0].tap();
	target.delay(1);
	target.frontMostApp().keyboard().typeString("9");
	target.frontMostApp().keyboard().typeString("\n");
	target.delay(1);
	target.frontMostApp().toolbar().buttons()[0].tap();
	target.frontMostApp().mainWindow().tableViews()[1].cells()[0].tap();
	batch(0);
	
	//target.frontMostApp().mainWindow().tableViews()[1].cells()[0].tap();
	//single(0);
	
	target.frontMostApp().mainWindow().tableViews()[0].buttons()["取消"].tap();
}

function done(){
	target.frontMostApp().mainWindow().tableViews()[0].cells()[1].tap();
	target.delay(1);
	target.frontMostApp().mainWindow().tableViews()[0].cells()[0].tap();
	target.frontMostApp().navigationBar().buttons()[4].tap();
	target.frontMostApp().navigationBar().buttons()[3].tap();
	target.frontMostApp().navigationBar().leftButton().tap();
	target.frontMostApp().navigationBar().leftButton().tap();
}

function others(){
	target.frontMostApp().mainWindow().tableViews()[0].cells()[2].tap();
	target.delay(1);
	target.frontMostApp().navigationBar().leftButton().tap();
	target.delay(2);
	target.frontMostApp().mainWindow().tableViews()[0].cells()[3].tap();
	target.delay(1);
	target.frontMostApp().navigationBar().leftButton().tap();
	target.delay(2);
}


//start
for(var times = 0;times<100;times++){
	login();
//batch
	for(var i =0; i<2; i++){
		target.frontMostApp().navigationBar().rightButton().tap();
		target.frontMostApp().mainWindow().tableViews()[0].cells()[0].tap();
		batch(i);
	}
//single
	for(var i =0;i<3;i++){
		target.frontMostApp().mainWindow().tableViews()[0].cells()[0].tap();
		single(i);
	}

//search
	search();

//functionlist 
	target.frontMostApp().navigationBar().leftButton().tap();

//done
	done();

//others
	others();

//logout
	target.frontMostApp().mainWindow().tableViews()[0].cells()[5].scrollToVisible();
	target.frontMostApp().mainWindow().tableViews()[0].cells()[5].buttons()[0].tap();
}


