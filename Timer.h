/*
 *  Timer.h
 *  Dispatch Benchmark
 *
 *  Created by Samuel Williams on 6/05/09.
 *  Copyright 2009 Orion Transfer Ltd. All rights reserved.
 *
 */

#ifndef _TIMER_H
#define _TIMER_H

typedef double TimeT;

class Timer {
protected:
	mutable TimeT m_last, m_total;
	
public:	
	Timer ();
	virtual ~Timer ();
	
	virtual void reset ();
	virtual TimeT time () const;
};

#endif
