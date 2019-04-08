#include <iostream>
#include <Foundation/Foundation.h>
#include "Timer.h"
#include <vector>
#include <string>

int g_count;

// C Dispatch
void basicFunction () {
	g_count += 1;
};

// C++ Base Dispatch
class CPPBase {
public:
	virtual void virualFunction () = 0;
};

// C++ Derived Dispatch
class CPP : public CPPBase {
public:
	virtual void virualFunction () {
		g_count += 1;
	}
};

// Objective-C Dispatch
@interface OBJC : NSObject
- (void) dynamicDispatch;
@end

@implementation OBJC
- (void) dynamicDispatch {
	g_count += 1;	
}
@end

// We only want to compare optimisations to dispatch mechanisms.
// We do this so that the compiler doesn't know the exact type of 
// the object it is dispatching to.
CPP * createCPP () {
	return new CPP();
}

typedef void (*CFuncPtr)();

CFuncPtr createCFuncPtr () {
	return basicFunction;
}

int main (int argc, char ** argv) {
	const unsigned TIMES = 20000;
	const unsigned REPEATS = 200000;
	Timer t;
	
	std::vector<TimeT> results(5);
	
	OBJC * o = [[OBJC alloc] init];
	CPP * c = createCPP();
	CPPBase * cbase = createCPP();
	
	CFuncPtr functionPointer = createCFuncPtr();
	
	std::cout.precision(4);
	std::cout << "Beginning benchmarks, please be patient..." << std::endl;

	unsigned l;
	for (l = 0; l < REPEATS; ++l) {
		if (l % 10000 == 0)
			std::cout << "Done " << ((float)l / REPEATS) * 100.0 << "%" << std::endl;
		
		// C Dispatch
		t.reset();
		for (unsigned i = 0; i < TIMES; ++i)
			basicFunction();
		results[0] += t.time();

		// C Pointer Dispatch
		t.reset();
		for (unsigned i = 0; i < TIMES; ++i)
			functionPointer();
		results[1] += t.time();
		
		// Base C++ Dispatch
		t.reset();
		for (unsigned i = 0; i < TIMES; ++i)
			cbase->virualFunction();
		results[2] += t.time();
		
		// Derived C++ Dispatch
		t.reset();
		for (unsigned i = 0; i < TIMES; ++i)
			c->virualFunction();
		results[3] += t.time();
		
		// Objective-C Dispatch
		t.reset();
		for (unsigned i = 0; i < TIMES; ++i)
			[o dynamicDispatch];
		results[4] += t.time();
	}
	
	std::vector<std::string> titles;
	titles.push_back("          C Dispatch: ");
	titles.push_back("  C Pointer Dispatch: ");
	titles.push_back("   Base C++ Dispatch: ");
	titles.push_back("Derived C++ Dispatch: ");
	titles.push_back("Objective-C Dispatch: ");
	
	for (unsigned k = 0; k < results.size(); ++k) {
		TimeT p = (results[k] / results[0]) * 100.0;
		std::cout << titles[k] << results[k] << "\t\t" << p << "% baseline" << std::endl;		
	}
}

