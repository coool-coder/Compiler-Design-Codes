digit [0-9]
day_num 0[1-9]|[1-2][0-9]|3[0-1]|[1-9]
day_num_name [2-3]?1(?:st)|2?2(?:nd)|2?3(?:rd)|([1-2]?[4-9]|[1-3]0|1[1-3])(?:th)
month_name (?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May?|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sept(?:ember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?) 
month_num 0[1-9]|1[0-2]

%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	FILE *out;
	char date_StdFormat[14] = "dd/mm/yyyy";
	char* ConversionToStdFormat(char StrArr[], int flag);
%}

%%
\n fprintf(out,"\n");
{day_num}\/{month_num}\/{digit}{2} fprintf(out,"%s",ConversionToStdFormat(yytext,1));
{day_num}\-{month_num}\-{digit}{2} fprintf(out,"%s",ConversionToStdFormat(yytext,2));
{day_num}\-{month_num}\-{digit}{4} fprintf(out,"%s",ConversionToStdFormat(yytext,3));
{day_num}\/{month_num}\/{digit}{4} fprintf(out,"%s",yytext);
{day_num}\-{month_name}\-{digit}{2} fprintf(out,"%s",ConversionToStdFormat(yytext,4));
{day_num}\-{month_name}\-{digit}{4}	fprintf(out,"%s",ConversionToStdFormat(yytext,5));
{day_num_name}[\ ]*{month_name}[\ ]*{digit}{4}	fprintf(out,"%s",ConversionToStdFormat(yytext,6));
{month_name}[\ ]*{day_num},?[\ ]*{digit}{4} 	fprintf(out,"%s",ConversionToStdFormat(yytext,7));
.					fprintf(out,"Invalid Date");
%%

void Cal_ddmmyyyy(char StrArr[]){
	int i=0, count1=0, count2=0;
	printf("%s\n", StrArr);
	while(StrArr[i]!='/' && StrArr[i]!='-'){
		count1++;
		i++;
	}
	i++;
	//for calculating mm
	while(StrArr[i]!='/' && StrArr[i]!='-'){
		count2++;
		i++;
	}
	if (count1==1){
		date_StdFormat[0]='0';
		date_StdFormat[1]=StrArr[0];
	}
	else {
		date_StdFormat[0]=StrArr[0];
		date_StdFormat[1]=StrArr[1];
	}
	if (count2==1){
		date_StdFormat[3]='0';
		date_StdFormat[4]=StrArr[count1+1];
	}
	else {
		date_StdFormat[3]=StrArr[count1+1];
		date_StdFormat[4]=StrArr[count1+2];
	}
	int year=((int)(StrArr[i+1])-'0')*10+((int)(StrArr[i+2])-'0');
	//taking upto 2017
	if (year<=17){
		date_StdFormat[6]='2';
		date_StdFormat[7]='0';
		date_StdFormat[8]=StrArr[++i];
		date_StdFormat[9]=StrArr[++i];
	}
	//otherwise it would be of 19's
	else{
		date_StdFormat[6]='1';
		date_StdFormat[7]='9';
		date_StdFormat[8]=StrArr[++i];
		date_StdFormat[9]=StrArr[++i];	
	}
	printf("End\n");
}

int ExtractingMonth(char Arr[]){
	if (strcmp("January", Arr)==0 || strcmp("Jan", Arr)==0){
		return 1;
	}
	else if (strcmp("February", Arr)==0 || strcmp("Feb", Arr)==0){
		return 2;
	}
	else if (strcmp("March", Arr)==0 || strcmp("Mar", Arr)==0){
		return 3;
	}
	else if (strcmp("April", Arr)==0 || strcmp("Apr", Arr)==0){
		return 4;
	}
	else if (strcmp("May", Arr)==0){
		return 5;
	}
	else if (strcmp("June", Arr)==0 || strcmp("Jun", Arr)==0){
		return 6;
	}
	else if (strcmp("July", Arr)==0 || strcmp("Jul", Arr)==0){
		return 7;
	}
	else if (strcmp("August", Arr)==0 || strcmp("Aug", Arr)==0){
		return 8;
	}
	else if (strcmp("September", Arr)==0 || strcmp("Sept", Arr)==0){
		return 9;
	}
	else if (strcmp("October", Arr)==0 || strcmp("Oct", Arr)==0){
		return 10;
	}
	else if (strcmp("November", Arr)==0 || strcmp("Nov", Arr)==0){
		return 11;
	}
	else if (strcmp("December", Arr)==0 || strcmp("Dec", Arr)==0){
		return 12;
	}
}

char* ConversionToStdFormat(char StrArr[], int flag){
	//printf("%s\n", StrArr);
	if (flag==1||flag==2){
		//for calculating dd
		Cal_ddmmyyyy(StrArr);
	}
	else if (flag==3){
		strcpy(date_StdFormat, StrArr);
		date_StdFormat[2] = '/';
		date_StdFormat[5] = '/';
	}
	else if(flag==4 || flag==5){
		int i=0;
		char temp[10];
		while(StrArr[i]!='/' && StrArr[i]!='-'){
			date_StdFormat[i]=StrArr[i];
			i++;
		}
		i++;
		int j=0;
		while(StrArr[i]!='/' && StrArr[i]!='-'){
			temp[j++] = StrArr[i++];
		}
		temp[j]='\0';
	//	printf("%s\n", temp);
		char buffer[3];
		int month = ExtractingMonth(temp);
	//	printf("%d\n",month);
		sprintf(buffer, "%d", month);
		if(strlen(buffer)==2){
			date_StdFormat[3]=buffer[0];
			date_StdFormat[4]=buffer[1];
		}
		else if (strlen(buffer)==1){
			date_StdFormat[3]='0';
			date_StdFormat[4]=buffer[0];	
		}
		if(flag==4)
		{
			int year=((int)(StrArr[i+1])-'0')*10+((int)(StrArr[i+2])-'0');
			//taking upto 2017
			if (year<=17){
				date_StdFormat[6]='2';
				date_StdFormat[7]='0';
				date_StdFormat[8]=StrArr[++i];
				date_StdFormat[9]=StrArr[++i];
			}
			//otherwise it would be of 19's
			else{
				date_StdFormat[6]='1';
				date_StdFormat[7]='9';
				date_StdFormat[8]=StrArr[++i];
				date_StdFormat[9]=StrArr[++i];	
			}
		}
		else
		{
			date_StdFormat[6]=StrArr[++i];
			date_StdFormat[7]=StrArr[++i];
			date_StdFormat[8]=StrArr[++i];
			date_StdFormat[9]=StrArr[++i];
		}
	}
	if (flag==6){
		int i=0;
		int date=0;
		while(StrArr[i]>='0' && StrArr[i]<='9')
		{
			date=date*10;
			date=date+((int)(StrArr[i])-'0');
			i=i+1;
		}
		if(date<10)
		{
			date_StdFormat[0]='0';
			date_StdFormat[1]=StrArr[0];
		}
		else
		{
			date_StdFormat[0]=StrArr[0];
			date_StdFormat[1]=StrArr[1];
		}
		while(StrArr[i]<'A' || StrArr[i]>'Z')
		{
			i=i+1;
		}
		int j=0;
		char month[20]="";	
		while(StrArr[i]!=' ')
		{
			month[j]=StrArr[i];
			i=i+1;
			j=j+1;
		}
		month[j]='\0';
		//printf("%s\n",month);
		char mon[3];
		int temp = ExtractingMonth(month);
		sprintf(mon, "%d", temp);
		if(strlen(mon)==2){
			date_StdFormat[3]=mon[0];
			date_StdFormat[4]=mon[1];
		}
		else if (strlen(mon)==1){
			date_StdFormat[3]='0';
			date_StdFormat[4]=mon[0];	
		}
		//printf("%s\n",mon);
		i=i+1;
		for(j=0;j<4;j++)
		{
			date_StdFormat[6+j]=StrArr[i+j];
		}
	}
	else if(flag==7)
	{
		int i=0;
		char month[20]="";	
		while(StrArr[i]!=' ')
		{
			month[i]=StrArr[i];
			i=i+1;
		}
		month[i]='\0';
		printf("%s\n",month);
		char mon[3];
		int temp = ExtractingMonth(month);
		sprintf(mon, "%d", temp);
	//	printf("%s\n",mon);
		i=i+1;
		if(strlen(mon)==2){
			date_StdFormat[3]=mon[0];
			date_StdFormat[4]=mon[1];
		}
		else if (strlen(mon)==1){
			date_StdFormat[3]='0';
			date_StdFormat[4]=mon[0];	
		}
		int date=0;
		int j=i;
		while(StrArr[i]>='0' && StrArr[i]<='9')
		{
			date=date*10;
			date=date+((int)(StrArr[i])-'0');
			i=i+1;
		}
		i=i+1;
		if(date<10)
		{
			date_StdFormat[0]='0';
			date_StdFormat[1]=StrArr[j];
		}
		else
		{
			date_StdFormat[0]=StrArr[j];
			date_StdFormat[1]=StrArr[j+1];
		}
		for(j=0;j<4;j++)
		{
			date_StdFormat[6+j]=StrArr[i+j];
		}
	}
	return date_StdFormat;
}

int main(int argc, char* argv[])
{	
	out = fopen("output.txt", "w");
	yyin = fopen(argv[1], "r");
	printf("enter");
	yylex();
	printf("no. of valid dates;");
	fclose(yyin);
	fclose(out);
	return 0;
}
