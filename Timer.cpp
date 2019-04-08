/*
 *  Timer.cpp
 *  Dispatch Benchmark
 *
 *  Created by Samuel Williams on 6/05/09.
 *  Copyright 2009 Orion Transfer Ltd. All rights reserved.
 *
 */

#include "Timer.h"
#include <sys/time.h>

TimeT system_time () {
	static struct timeval t;
	gettimeofday (&t, (struct timezone*)0);
	return ((TimeT)t.tv_sec) + ((TimeT)t.tv_usec / 1000000.0);
}

Timer::Timer () {
	this->reset();
}

Timer::~Timer () {
	
}

void Timer::reset () {
	this->m_last = system_time();
	this->m_total = 0.0;
}

TimeT Timer::time () const {
	TimeT current = system_time();
	this->m_total += current - this->m_last;
	this->m_last = current;
	return this->m_total;
}
