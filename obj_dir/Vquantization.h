// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VQUANTIZATION_H_
#define _VQUANTIZATION_H_  // guard

#include "verilated.h"

//==========

class Vquantization__Syms;

//----------

VL_MODULE(Vquantization) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_OUT8(outputInt8,7,0);
    VL_IN(inputFP,31,0);
    VL_IN(scale,31,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    CData/*7:0*/ quantization__DOT__j;
    CData/*7:0*/ quantization__DOT__temp;
    CData/*7:0*/ quantization__DOT__d0__DOT__expC;
    SData/*9:0*/ quantization__DOT__cvrtInt;
    IData/*31:0*/ quantization__DOT__scaledFp;
    IData/*22:0*/ quantization__DOT__manScale;
    IData/*31:0*/ quantization__DOT__d0__DOT__i;
    IData/*24:0*/ quantization__DOT__d0__DOT__mantissaProd;
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vquantization__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vquantization);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vquantization(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vquantization();
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vquantization__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vquantization__Syms* symsp, bool first);
  private:
    static QData _change_request(Vquantization__Syms* __restrict vlSymsp);
    static QData _change_request_1(Vquantization__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__1(Vquantization__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vquantization__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vquantization__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vquantization__Syms* __restrict vlSymsp) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
