/*
 * fwrisc_instr_tests_ldst.h
 *
 *
 * Copyright 2018 Matthew Ballance
 *
 * Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in
 * writing, software distributed under the License is
 * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied.  See
 * the License for the specific language governing
 * permissions and limitations under the License.
 *
 *  Created on: Oct 30, 2018
 *      Author: ballance
 */

#ifndef INCLUDED_FWRISC_INSTR_TESTS_LDST_H
#define INCLUDED_FWRISC_INSTR_TESTS_LDST_H
#include "fwrisc_instr_tests.h"

class fwrisc_instr_tests_ldst : public fwrisc_instr_tests {
public:
	fwrisc_instr_tests_ldst();

	virtual ~fwrisc_instr_tests_ldst();
};

#endif /* INCLUDED_FWRISC_INSTR_TESTS_LDST_H */