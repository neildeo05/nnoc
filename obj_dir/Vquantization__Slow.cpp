// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vquantization.h for the primary calling header

#include "Vquantization.h"
#include "Vquantization__Syms.h"

//==========

VL_CTOR_IMP(Vquantization) {
    Vquantization__Syms* __restrict vlSymsp = __VlSymsp = new Vquantization__Syms(this, name());
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vquantization::__Vconfigure(Vquantization__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

Vquantization::~Vquantization() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void Vquantization::_eval_initial(Vquantization__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::_eval_initial\n"); );
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vquantization::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::final\n"); );
    // Variables
    Vquantization__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vquantization::_eval_settle(Vquantization__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::_eval_settle\n"); );
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
}

void Vquantization::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::_ctor_var_reset\n"); );
    // Body
    inputFP = VL_RAND_RESET_I(32);
    scale = VL_RAND_RESET_I(32);
    outputInt8 = VL_RAND_RESET_I(8);
    quantization__DOT__scaledFp = VL_RAND_RESET_I(32);
    quantization__DOT__j = 0;
    quantization__DOT__temp = 0;
    quantization__DOT__cvrtInt = VL_RAND_RESET_I(10);
    quantization__DOT__manScale = VL_RAND_RESET_I(23);
    quantization__DOT__d0__DOT__i = 0;
    quantization__DOT__d0__DOT__mantissaProd = VL_RAND_RESET_I(25);
    quantization__DOT__d0__DOT__expC = VL_RAND_RESET_I(8);
}
