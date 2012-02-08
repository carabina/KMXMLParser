//
//  KMXMLParser.m
//  KMXMLClass
//
//  Created by Kieran McGrady http://www.kieranmcgrady.com
//  Twitter: http://twitter.com/kmcgrady
//
//  You can use this code freely in any project commercial and non-
//  commercial. You must retain this header.

#import "KMXMLParser.h"


@implementation KMXMLParser
@synthesize parserDelegate = _parserDelegate;

- (id)initWithURL:(NSString *)url
{
	NSURL *xmlURL = [NSURL URLWithString:url];
	[self beginParsing:xmlURL];
    
    return self;
}

-(void)beginParsing:(NSURL *)xmlURL
{
	posts = [[NSMutableArray alloc] init];
	parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	[parser setDelegate:self];
	
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
}

-(NSMutableArray *)posts
{
	return posts;
}

#pragma mark NSXMLParser Delegate Methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{

}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.parserDelegate parserCompletedSuccessfully];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.parserDelegate parserDidFailWithError:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	element = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) 
	{
		elements = [[NSMutableDictionary alloc] init];
		title = [[NSMutableString alloc] init];
		date = [[NSMutableString alloc] init];
		summary = [[NSMutableString alloc] init];
		link = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"item"]) 
	{
		[elements setObject:title forKey:@"title"];
		[elements setObject:date forKey:@"date"];
		[elements setObject:summary forKey:@"summary"];
		[elements setObject:link forKey:@"link"];
		
		[posts addObject:elements ];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([element isEqualToString:@"title"]) 
	{
		[title appendString:string];
	} 
	else if ([element isEqualToString:@"pubDate"]) 
	{
		[date appendString:string];
	} 
	else if ([element isEqualToString:@"description"]) 
	{
		[summary appendString:string];
	} 
	else if ([element isEqualToString:@"link"]) 
	{
		[link appendString:string];
	} 
}


@end
