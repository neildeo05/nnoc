// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vquantization.h for the primary calling header

#include "Vquantization.h"
#include "Vquantization__Syms.h"

//==========

void Vquantization::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vquantization::eval\n"); );
    Vquantization__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("quantization.sv", 1, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vquantization::_eval_initial_loop(Vquantization__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("quantization.sv", 1, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vquantization::_combo__TOP__1(Vquantization__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::_combo__TOP__1\n"); );
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->quantization__DOT__d0__DOT__expC = (0xffU 
                                                & (((vlTOPp->inputFP 
                                                     >> 0x17U) 
                                                    - 
                                                    (vlTOPp->scale 
                                                     >> 0x17U)) 
                                                   - (IData)(0x7fU)));
    vlTOPp->quantization__DOT__d0__DOT__mantissaProd 
        = (0x1ffffffU & VL_DIV_III(25, (0x800000U | 
                                        (0x7fffffU 
                                         & vlTOPp->inputFP)), 
                                   (0x800000U | (0x7fffffU 
                                                 & vlTOPp->scale))));
    vlTOPp->quantization__DOT__d0__DOT__i = 0U;
    while (VL_GTS_III(1,32,32, 0x18U, vlTOPp->quantization__DOT__d0__DOT__i)) {
        if ((0x1000000U & vlTOPp->quantization__DOT__d0__DOT__mantissaProd)) {
            vlTOPp->quantization__DOT__d0__DOT__i = 0x17U;
        } else {
            vlTOPp->quantization__DOT__d0__DOT__mantissaProd 
                = (0x1ffffffU & (vlTOPp->quantization__DOT__d0__DOT__mantissaProd 
                                 << 1U));
            vlTOPp->quantization__DOT__d0__DOT__expC 
                = (0xffU & ((IData)(vlTOPp->quantization__DOT__d0__DOT__expC) 
                            - (IData)(1U)));
        }
        vlTOPp->quantization__DOT__d0__DOT__i = ((IData)(1U) 
                                                 + vlTOPp->quantization__DOT__d0__DOT__i);
    }
    vlTOPp->quantization__DOT__d0__DOT__mantissaProd 
        = (0x1ffffffU & (vlTOPp->quantization__DOT__d0__DOT__mantissaProd 
                         << 1U));
    vlTOPp->quantization__DOT__d0__DOT__expC = (0xffU 
                                                & ((IData)(1U) 
                                                   + (IData)(vlTOPp->quantization__DOT__d0__DOT__expC)));
    vlTOPp->quantization__DOT__scaledFp = ((0x80000000U 
                                            & (vlTOPp->inputFP 
                                               ^ vlTOPp->scale)) 
                                           | (((IData)(vlTOPp->quantization__DOT__d0__DOT__expC) 
                                               << 0x17U) 
                                              | (0x7fffffU 
                                                 & vlTOPp->quantization__DOT__d0__DOT__mantissaProd)));
    vlTOPp->quantization__DOT__cvrtInt = 1U;
    vlTOPp->quantization__DOT__manScale = (0x7fffffU 
                                           & vlTOPp->quantization__DOT__scaledFp);
    vlTOPp->quantization__DOT__temp = (0xffU & (vlTOPp->quantization__DOT__scaledFp 
                                                >> 0x17U));
    vlTOPp->quantization__DOT__j = 0U;
    while ((8U > (IData)(vlTOPp->quantization__DOT__j))) {
        if (((IData)(vlTOPp->quantization__DOT__j) 
             >= (IData)(vlTOPp->quantization__DOT__temp))) {
            vlTOPp->quantization__DOT__j = 8U;
        } else {
            vlTOPp->quantization__DOT__cvrtInt = (0x3ffU 
                                                  & ((IData)(vlTOPp->quantization__DOT__cvrtInt) 
                                                     << 1U));
            vlTOPp->quantization__DOT__cvrtInt = ((0x3feU 
                                                   & (IData)(vlTOPp->quantization__DOT__cvrtInt)) 
                                                  | (1U 
                                                     & (vlTOPp->quantization__DOT__manScale 
                                                        >> 0x16U)));
            vlTOPp->quantization__DOT__manScale = (0x7fffffU 
                                                   & (vlTOPp->quantization__DOT__manScale 
                                                      << 1U));
        }
        vlTOPp->quantization__DOT__j = (0xffU & ((IData)(1U) 
                                                 + (IData)(vlTOPp->quantization__DOT__j)));
    }
    vlTOPp->quantization__DOT__cvrtInt = ((0x7fU < (IData)(vlTOPp->quantization__DOT__cvrtInt))
                                           ? 0x7fU : 0x380U);
    vlTOPp->outputInt8 = (0xffU & (IData)(vlTOPp->quantization__DOT__cvrtInt));
}

void Vquantization::_eval(Vquantization__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::_eval\n"); );
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
}

VL_INLINE_OPT QData Vquantization::_change_request(Vquantization__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::_change_request\n"); );
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vquantization::_change_request_1(Vquantization__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::_change_request_1\n"); );
    Vquantization* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vquantization::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vquantization::_eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG
