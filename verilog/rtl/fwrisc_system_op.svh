/****************************************************************************
 * fwrisc_system_op.svh
 *
 * Copyright 2019 Matthew Ballance
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
 ****************************************************************************/

parameter [3:0]
  OP_TYPE_ECALL  = 1'd0,
  OP_TYPE_EBREAK = (OP_TYPE_ECALL + 1'd1),
  OP_TYPE_ERET   = (OP_TYPE_EBREAK + 1'd1),
  OP_TYPE_WFI    = (OP_TYPE_ERET + 1'd1)
  ;

  
